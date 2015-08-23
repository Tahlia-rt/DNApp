//
//  MenuViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTouchTop(controller: MenuViewController)
    func menuViewControllerDidTouchRecent(controller: MenuViewController)
}

class MenuViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    weak var delegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        dialogView.animation = "fall"
        dialogView.animate()
    }

    @IBAction func topButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchTop(self)
        closeButtonDidTouch(sender)
    }

    @IBAction func recentButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchRecent(self)
        closeButtonDidTouch(sender)
    }

    @IBAction func loginButtonDidTouch(sender: AnyObject) {

    }
}
