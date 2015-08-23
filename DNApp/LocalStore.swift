//
//  LocalStore.swift
//  DNApp
//
//  Created by Karlis Berzins on 23/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

struct LocalStore {

    static let userDefaults = NSUserDefaults.standardUserDefaults()

    static func saveToken(token: String) {
        userDefaults.setObject(token, forKey: "tokenKey")
        userDefaults.synchronize()
    }

    static func getToken() -> String? {
        return userDefaults.stringForKey("tokenKey")
    }

    static func deleteToken() {
        userDefaults.removeObjectForKey("tokenKey")
        userDefaults.synchronize()
    }

    static func saveUpvotedStory(storyId: Int) {
        appendId(storyId, toKey: "upvotedStoriesKey")
    }

    static func saveUpvotedComment(commentId: Int) {
        appendId(commentId, toKey: "upvotedCommentsKey")
    }

    static func isStoryUpvoted(storyId: Int) -> Bool {
        return arrayForKey("upvotedStoriesKey", containsId: storyId)
    }

    static func isCommentUpvoted(commentId: Int) -> Bool {
        return arrayForKey("upvotedCommentsKey", containsId: commentId)
    }

// MAKR: Helper

    private static func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return elements.contains(id)
    }

    private static func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !elements.contains(id) {
            userDefaults.setObject(elements + [id], forKey: key)
            userDefaults.synchronize()
        }
    }
}
