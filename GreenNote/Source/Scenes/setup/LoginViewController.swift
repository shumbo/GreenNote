//
//  LoginViewController.swift
//  GreenNote
//
//  Created by Shun Kashiwa on 2018/05/16.
//  Copyright © 2018 Shun Kashiwa. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var loginWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginWebView.customUserAgent = Constants.UserAgent
        loginWebView.navigationDelegate = self
        loginWebView.load(URLRequest(url: URL(string: "https://www.grammarly.com/signin")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle cancel button
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView.url?.absoluteString == "https://app.grammarly.com/" {
            self.parent?.dismiss(animated: true, completion: nil)
        }
    }
}