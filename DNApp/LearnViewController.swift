//
//  LearnViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var bookImageView: SpringImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func learnButtonDidTouch(sender: AnyObject) {
        bookImageView.animation = "pop"
        bookImageView.animate()

        openURL("http://designcode.io")
    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func twitterButtonDidTouch(sender: AnyObject) {
        openURL("http://twitter.con/MengTo")
    }

    func openURL(url: String) {
        let targetUrl = NSURL(string: url)!
        UIApplication.sharedApplication().openURL(targetUrl)
    }
}
