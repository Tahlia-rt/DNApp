//
//  WebViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
