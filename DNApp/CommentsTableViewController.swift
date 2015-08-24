//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 17/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentTableViewCellDelegate, StoryTableViewCellDelegate, ReplyViewControllerDelegate {

    var story: JSON!
    var comments: [JSON]!
    var transitionManager = TransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        comments = flattenComments(story["comments"].array ?? [])

        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension

        refreshControl?.addTarget(self, action: "reloadStory", forControlEvents: .ValueChanged)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell

        if let storyCell = cell as? StoryTableViewCell {
            storyCell.configureWithStory(story)
            storyCell.delegate = self
        }

        if let commentCell = cell as? CommentTableViewCell {
            let comment = comments[indexPath.row - 1]
            commentCell.configureWithComment(comment)
            commentCell.delegate = self
        }

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            let toViewController = segue.destinationViewController as! ReplyViewController
            if let cell = sender as? CommentTableViewCell {
                let indexPath = tableView.indexPathForCell(cell)!
                let comment = comments[indexPath.row - 1]
                toViewController.comment = comment
            } else if let _ = sender as? StoryTableViewCell {
                toViewController.story = story
            }

            toViewController.delegate = self
            toViewController.transitioningDelegate = transitionManager
        }
    }

    func reloadStory() {
        view.showLoading()
        DNService.storyForId(story["id"].int!) { (JSON) -> () in
            self.view.hideLoading()
            self.story = JSON["story"]
            self.comments = self.flattenComments(JSON["story"]["comments"].array ?? [])
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    @IBAction func shareButtonDidTouch(sender: AnyObject) {
        let title = story["title"].string ?? ""
        let url = story["url"].string ?? ""
        let activityViewController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)
        activityViewController.setValue(title, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }

    // MARK: For comment flattening

    func flattenComments(comments: [JSON]) -> [JSON] {
        let flattenedComments = comments.map(commentsForComment).reduce([], combine: +)
        return flattenedComments
    }

    func commentsForComment(comment: JSON) -> [JSON] {
        let comments = comment["comments"].array ?? []
        return comments.reduce([comment]) { acc, x in
            acc + self.commentsForComment(x)
        }
    }

    // MARK: ReplyViewControllerDelegate

    func replyViewControllerDidSend(controller: ReplyViewController) {
        reloadStory()
    }

    // MARK: CommentTableViewCellDelegate

    func commentTableViewCellDidTouchUpvote(cell: CommentTableViewCell) {
        if let token = LocalStore.getToken() {
            let indexPath = tableView.indexPathForCell(cell)!
            let comment = comments[indexPath.row - 1]
            let commentId = comment["id"].int!

            DNService.upvoteCommentWithId(commentId, token: token){ (successfull) -> () in
                // Do something
            }

            LocalStore.saveUpvotedComment(commentId)
            cell.configureWithComment(comment)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }

    func commentTableViewCellDidTouchComment(cell: CommentTableViewCell) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }

    // MARK: StoriesTableViewCellDelegate

    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject) {
        if let token = LocalStore.getToken() {
            let storyId = story["id"].int!

            DNService.upvoteStoryWithId(storyId, token: token){ (successfull) -> () in
                // Do something
            }

            LocalStore.saveUpvotedStory(storyId)
            cell.configureWithStory(story)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }

    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }
}
