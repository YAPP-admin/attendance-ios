//
//  PolicyWebView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/10/26.
//

import SwiftUI
import WebKit
 
struct PolicyWebView: UIViewRepresentable {
   
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
      
        let webView = WKWebView()
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<PolicyWebView>) {
        
    }
}
