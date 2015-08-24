//
//  DNService.swift
//  DNApp
//
//  Created by Karlis Berzins on 23/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import Alamofire

struct DNService {
    // Doc: https://github.com/metalabdesign/dn_api_v2

    private static let baseURL = "https://www.designernews.co"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"

    private enum ResourcePath: CustomStringConvertible {
        case Login
        case Stories
        case StoryId(storyId: Int)
        case StoryUpvote(storyId: Int)
        case StoryReply(storyId: Int)
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)

        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Stories: return "/api/v1/stories"
            case .StoryId(let id): return "/api/v1/stories/\(id)"
            case .StoryUpvote(let id): return "/api/v1/stories/\(id)/upvote"
            case .StoryReply(let id): return "/api/v1/stories/\(id)/reply"
            case .CommentUpvote(let id): return "/api/v1/comments/\(id)/upvote"
            case .CommentReply(let id): return "/api/v1/comments/\(id)/reply"
            }
        }
    }

    static func storiesForSection(section: String, page: Int, response: (JSON) -> ()) {
        let urlString = baseURL + ResourcePath.Stories.description + "/" + section
        let parameters = ["page": String(page), "client_id": clientID]
        Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { (_, _, data) in
            let stories = JSON(data.value ?? [])
            response(stories)
        }
    }

    static func loginWithEmail(email: String, password: String, response: (token: String?) -> ()) {
        let urlString = baseURL + ResourcePath.Login.description
        let parameters = [
            "grant_type": "password",
            "username": email,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret
        ]

        Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { (_, _, data) -> Void in
            let json = JSON(data.value!)
            let token = json["access_token"].string
            response(token: token)
        }
    }

    static func upvoteStoryWithId(storyId: Int, token: String, response: (successfull: Bool) -> ()) {
        let urlString = baseURL + ResourcePath.StoryUpvote(storyId: storyId).description
        upvoteWithUrlString(urlString, token: token, response: response)
    }

    static func upvoteCommentWithId(commentId: Int, token: String, response: (successfull: Bool) -> ()) {
        let urlString = baseURL + ResourcePath.CommentReply(commentId: commentId).description
        upvoteWithUrlString(urlString, token: token, response: response)
    }

    static func replyStoryWithId(storyId: Int, token: String, body: String, response: (successfull: Bool) -> ()) {
        let urlString = baseURL + ResourcePath.StoryReply(storyId: storyId).description
        replyWithUrlString(urlString, token: token, body: body, response: response)
    }

    static func replyCommentWithId(commentId: Int, token: String, body: String, response: (successfull: Bool) -> ()) {
        let urlString = baseURL + ResourcePath.CommentReply(commentId: commentId).description
        replyWithUrlString(urlString, token: token, body: body, response: response)
    }

    static func storyForId(storyId: Int, response: (JSON) -> ()) {
        let urlString = baseURL + ResourcePath.StoryId(storyId: storyId).description
        let parameters = ["client_id": clientID]
        Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { (_, _, data) -> Void in
            let story = JSON(data.value ?? [])
            response(story)
        }
    }

    // MARK: private functions

    private static func upvoteWithUrlString(urlString: String, token: String, response: (successfull: Bool) -> ()) {
        Alamofire.request(.POST, urlString, headers: ["Authorization": "Bearer \(token)"]).responseJSON { (_, urlResponse, _) -> Void in
            let successful = urlResponse?.statusCode == 200
            response(successfull: successful)
        }
    }

    private static func replyWithUrlString(urlString: String, token: String, body: String, response: (successfull: Bool) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = "comment[body]=\(body)".dataUsingEncoding(NSUTF8StringEncoding)

        Alamofire.request(request).responseJSON { (_, _, data) -> Void in
            let json = JSON(data.value!)
            if let _ = json["comment"].string {
                response(successfull: true)
            } else {
                response(successfull: false)
            }
        }
    }
}
