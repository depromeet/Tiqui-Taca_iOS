//
//  WebView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  var url: URL?
  
  func makeUIView(context: Context) -> WKWebView {
    guard let url = url else {
      return WKWebView()
    }
    
    let webView = WKWebView()
    webView.load(URLRequest(url: url))
    return webView
  }
  
  func updateUIView(_ webView: WKWebView, context: Context) { }
}

struct WebView_Previews: PreviewProvider {
  static var previews: some View {
    WebView(url: URL(string: "https://developer.apple.com/kr/"))
  }
}
