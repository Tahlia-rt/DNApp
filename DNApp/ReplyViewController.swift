//
//  ReplyViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 24/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func replyViewControllerDidSend(controller: ReplyViewController)
}

class ReplyViewController: UIViewController {

    var story: JSON = []
    var comment: JSON = []
    @IBOutlet weak var replyTextView: UITextView!
    weak var delegate: ReplyViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        replyTextView.becomeFirstResponder()
    }

    @IBAction func sendButtonDidTouch(sender: AnyObject) {
        view.showLoading()
        let token = LocalStore.getToken()!
        let body = replyTextView.text

        if let storyId = story["id"].int {
            DNService.replyStoryWithId(storyId, token: token, body: body) { (successfull) -> () in
                self.view.hideLoading()
                if successfull {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                } else {
                    self.showAlert()
                }
            }
        }

        if let commentId = comment["id"].int {
            DNService.replyCommentWithId(commentId, token: token, body: body) { (successfull) -> () in
                if successfull {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                } else {
                    self.showAlert()
                }
            }
        }

    }

    func showAlert() {
        let alert = UIAlertController(title: "Oh noes.", message: "Something went wrong. Your message wasn't sent. Try again and save your text just in case.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
