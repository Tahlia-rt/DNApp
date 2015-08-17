//
//  CommentTableViewCell.swift
//  DNApp
//
//  Created by Karlis Berzins on 17/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!

    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {

    }

    @IBAction func replyButtonDidTouch(sender: AnyObject) {

    }

    func configureWithComment(comment: JSON) {
        let userPortraitUrl = comment["user_portrait_url"].string!
        let userDisplayName = comment["user_display_name"].string!
        let createdAt = comment["created_at"].string!
        let userJob = comment["user_job"].string!
        let voteCount = comment["vote_count"].int!
        let body = comment["body"].string!

        avatarImageView.image = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle("\(voteCount)", forState: .Normal)
        commentTextView.text = body
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
