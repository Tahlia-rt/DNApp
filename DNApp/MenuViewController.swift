//
//  MenuViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

        dialogView.animation = "fall"
        dialogView.animate()
    }
}
