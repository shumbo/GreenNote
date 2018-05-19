//
//  MainViewController.swift
//  GreenNote
//
//  Created by Shun Kashiwa on 2018/05/16.
//  Copyright © 2018 Shun Kashiwa. All rights reserved.
//

import UIKit
import WebKit

private enum PageType: String {
    case TOP
    case EDITOR
    case OTHER
}
private struct Document: Codable {
    var title: String
    var content: String
}

class MainViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    
    private var _currentPage: PageType = .TOP
    private var currentPage: PageType {
        get {
            return self._currentPage
        }
        set(nextType) {
            self._currentPage = nextType
            self.onPageTypeChange(page: nextType)
        }
    }

    var webView: WKWebView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        var js = ""
        let path = Bundle.main.path(forResource: "bundle", ofType: "js")
        if let script = try? String.init(contentsOfFile: path!, encoding: .utf8) {
            js = script
        }
        userContentController.addUserScript(WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        userContentController.add(self, name: "PageType")
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.delegate = self
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scrollView.bounces = false
        webView.customUserAgent = Constants.UserAgent
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://app.grammarly.com")!))
        
        onPageTypeChange(page: self.currentPage) // for the first time
    }
    
    private func onPageTypeChange(page:PageType){
        switch page {
        case .EDITOR:
            self.shareButton.isEnabled = true
            break
        case .TOP:
            self.shareButton.isEnabled = false
            break
        case .OTHER:
            self.shareButton.isEnabled = false
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        self.webView.evaluateJavaScript("window.__GreenNote__.getDocument()") { [weak self] (result, error ) in
            if error != nil {
                return
            }
            guard let str = result as? String else {
                return
            }
            guard let document = try? JSONDecoder().decode(Document.self, from: str.data(using: .utf8)!) else {
                return
            }
            guard let attributedContent = try? NSAttributedString(data: document.content.data(using: .utf8)!, options: [.documentType:NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
                return
            }
            let activityVC = UIActivityViewController(activityItems: [attributedContent.string], applicationActivities: nil)
            activityVC.popoverPresentationController?.barButtonItem = sender
            self?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView.url?.host != "app.grammarly.com" {
            UserDefaults.standard.set(false, forKey: Constants.Defaults.isLoggedIn.rawValue)
            let welcomeSB = UIStoryboard(name: "welcome", bundle: nil)
            guard let vc = welcomeSB.instantiateInitialViewController() else { return }
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "PageType":
            guard let str = message.body as? String else { return }
            guard let nextType = PageType(rawValue: str) else { return }
            self.currentPage = nextType
            break
        default:
            break
        }
    }
    
    // Prevent zooming on main webview
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
