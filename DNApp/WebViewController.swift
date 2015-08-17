//
//  WebViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    var hasFinishedLoading = false

    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let targetUrl = NSURL(string: url)!
        let request = NSURLRequest(URL: targetUrl)
        webView.delegate = self
        webView.loadRequest(request)
    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    }

    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.hidden = true
        } else {
            if hasFinishedLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.01
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }
        }

        delay(0.008) { [weak self] in
            if let _self = self {
                _self.updateProgress()
            }
        }
    }

// MARK: WebView Delegate

    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishedLoading = false
        updateProgress()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        delay(1) { [weak self] in
            if let _self = self {
                _self.hasFinishedLoading = true
            }
        }
    }

    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
}
