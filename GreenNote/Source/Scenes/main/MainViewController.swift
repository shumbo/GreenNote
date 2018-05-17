//
//  MainViewController.swift
//  GreenNote
//
//  Created by Shun Kashiwa on 2018/05/16.
//  Copyright © 2018 Shun Kashiwa. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webview.customUserAgent = Constants.UserAgent
        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: "https://app.grammarly.com")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView.url?.host != "app.grammarly.com" {
            UserDefaults.standard.set(false, forKey: Constants.Defaults.isLoggedIn.rawValue)
            let welcomeSB = UIStoryboard(name: "welcome", bundle: nil)
            guard let vc = welcomeSB.instantiateInitialViewController() else { return }
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
}
