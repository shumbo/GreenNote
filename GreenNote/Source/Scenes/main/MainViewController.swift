//
//  MainViewController.swift
//  GreenNote
//
//  Created by Shun Kashiwa on 2018/05/16.
//  Copyright © 2018 Shun Kashiwa. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

private enum PageType: String {
    case TOP
    case EDITOR
    case OTHER
}

class MainViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    private let disposeBag = DisposeBag()
    
    private let currentPage: BehaviorSubject<PageType> = BehaviorSubject<PageType>(value: .TOP)

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
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scrollView.bounces = false
        webView.customUserAgent = Constants.UserAgent
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://app.grammarly.com")!))
        
        
        currentPage.subscribe { e in
            guard let page: PageType = e.element else { return }
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
        }.disposed(by: self.disposeBag)
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
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "PageType":
            guard let str = message.body as? String else { return }
            guard let nextType = PageType(rawValue: str) else { return }
            self.currentPage.onNext(nextType)
            break
        default:
            break
        }
    }
}
