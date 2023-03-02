//
//  WebViewController.swift
//  Baseet App
//
//  Created by APPLE on 15/11/22.
//

import UIKit
import WebKit


class WebViewController: UIViewController {

    @IBOutlet weak var webVieww: WKWebView!
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURLString = "https://baseetqa.com/"
        let url = URL(string: myURLString)
        let request = URLRequest(url: url!)
        webVieww.navigationDelegate = self
        webVieww.load(request)
     
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
   

}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.showLoadingIndicatorClosure?()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoadingIndicatorClosure?()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
