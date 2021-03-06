//
//  StoryTableViewCell.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

protocol StoryTableViewCellDelegate: class {
    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject)
    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject)
}

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    weak var delegate: StoryTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        SoundPlayer.play("upvote.wav")
        upvoteButton.animation = "pop"
        upvoteButton.force = 3
        upvoteButton.animate()

        delegate?.storyTableViewCellDidTouchUpvote(self, sender: sender)
    }

    @IBAction func commentButtonDidTouch(sender: AnyObject) {
        commentButton.animation = "pop"
        commentButton.force = 3
        commentButton.animate()

        delegate?.storyTableViewCellDidTouchComment(self, sender: sender)
    }

    func configureWithStory(story: JSON) {

        let title = story["title"].string ?? ""
        let badge = story["badge"].string ?? ""
        let userPortraitUrl = story["user_portrait_url"].string
        let userDisplayName = story["user_display_name"].string ?? ""
        let createdAt = story["created_at"].string!
        let userJob = story["user_job"].string ?? ""
        let voteCount = story["vote_count"].int ?? 0
        let commentCount = story["comment_count"].int ?? 0
        let comment = story["comment"].string ?? ""
        let commentHTML = story["comment_html"].string ?? ""

        titleLabel.text = title
        badgeImageView.image = UIImage(named: "badge-" + badge)
        avatarImageView.url = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle("\(voteCount)", forState: .Normal)
        commentButton.setTitle("\(commentCount)", forState: .Normal)

        if let commentTextView = commentTextView {
            commentTextView.attributedText = htmlToAttributedString(commentHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>")
            commentTextView.text = comment
        }

        let storyId = story["id"].int!
        if LocalStore.isStoryUpvoted(storyId) {
            upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: .Normal)
            upvoteButton.setTitle(String(voteCount + 1), forState: .Normal)
        } else {
            upvoteButton.setImage(UIImage(named: "icon-upvote"), forState: .Normal)
            upvoteButton.setTitle(String(voteCount), forState: .Normal)
        }
    }
}
