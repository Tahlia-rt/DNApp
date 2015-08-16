//
//  LoginViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 15/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

// MARK: Actions

    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        dialogView.animation = "shake"
        dialogView.animate()
    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "zoomOut"
        dialogView.animate()
    }
}
