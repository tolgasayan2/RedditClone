//
//  DetailViewController.swift
//  RedditCloneApp
//
//  Created by Tolga Sayan on 1.02.2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
  
  var webView: WKWebView!
  var str = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      webView = WKWebView()
          webView.navigationDelegate = self
          view = webView
      let encodedUrl = str.addingPercentEncoding(
        withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
      let url = URL(string: "https://www.reddit.com/search/?q=\(encodedUrl)")!
      webView.load(URLRequest(url: url))
      webView.allowsBackForwardNavigationGestures = true
    }
    


}
