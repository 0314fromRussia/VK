//
//  LoginViewController.swift
//  VKlient
//
//  Created by Никита Дмитриев on 10.10.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit
import WebKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7675928"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"), //262150
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        
        
    }
    
    
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        Session.shared.token = params["access_token"] ?? ""
        Session.shared.userId = Int(params["user_id"] ?? "") ?? 0
        print(Session.shared.token)
        
        if Session.shared.token != "" && Session.shared.userId != 0 {
            performSegue(withIdentifier: "Friends", sender: nil)
        } else {
            return
        }
        
        
        decisionHandler(.cancel)
    }
    
}
