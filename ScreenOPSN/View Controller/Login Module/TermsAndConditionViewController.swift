//
//  TermsAndConditionViewController.swift
//  ScreenOPSN
//
//  Created by Apple on 27/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WebKit


class TermsAndConditionViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self

        let url = URL(string: "http://livewire-ssams-com.stackstaging.com/terms-and-conditions")!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
        
     }
    
    func webViewDidStartLoad(_ : WKWebView) {
    Global.showActivityIndicator(self.view)

    }

    func webViewDidFinishLoad(_ : WKWebView) {
        Global.hideActivityIndicator(self.view)
    }
    
    @IBAction func dismissView(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
      }
      
 }
