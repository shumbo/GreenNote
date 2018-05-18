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
    
    enum LoginMode: String {
        case Signin = "https://www.grammarly.com/signin"
        case Signup = "https://www.grammarly.com/signup?page=free"
    }
    var mode: LoginMode!
    
    @IBOutlet weak var loginWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginWebView.customUserAgent = Constants.UserAgent
        loginWebView.navigationDelegate = self
        
        print(self.mode)
        loginWebView.load(URLRequest(url: URL(string: mode.rawValue)!))
        
        activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle cancel button
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        if webView.url?.host == "app.grammarly.com" {
            let alert = UIAlertController(title: "Logging in...", message: nil, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.parent?.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(true, forKey: Constants.Defaults.isLoggedIn.rawValue)
                let mainSB = UIStoryboard(name: "main", bundle: nil)
                guard let vc = mainSB.instantiateInitialViewController() else { return }
                UIApplication.shared.keyWindow?.rootViewController = vc
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
