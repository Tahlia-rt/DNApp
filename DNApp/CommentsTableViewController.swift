//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 17/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {

    var story: JSON!
    var comments: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()

        comments = story["comments"]

        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell

        if let storyCell = cell as? StoryTableViewCell {
            storyCell.configureWithStory(story)
        }

        if let commentCell = cell as? CommentTableViewCell {
            let comment = comments[indexPath.row - 1]
            commentCell.configureWithComment(comment)
        }

        return cell
    }
}
