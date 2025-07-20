//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 31/08/2024.
//

import SwiftUI
import WebKit

// WebView Struct to Wrap WKWebView for use in SwiftUI
public struct GoogleFormView: UIViewRepresentable {
    var url: URL
    @Binding var wkWebView: WKWebView?
    @Binding var formSubmitted: Bool // Binding to detect form submission

    public init(url: URL, wkWebView: Binding<WKWebView?>, formSubmitted: Binding<Bool>) {
        self.url = url
        self._wkWebView = wkWebView
        self._formSubmitted = formSubmitted
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: GoogleFormView

        init(_ parent: GoogleFormView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                print("Current URL: \(url)")

                // Detect if the URL contains a form completion indicator
                if url.contains("formResponse") || url.contains("thank_you") || url.contains("submitted") {


                    self.parent.formSubmitted = true
                }
            }
            decisionHandler(.allow)
        }
    }

    // Create the WKWebView and configure it
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        self.wkWebView = webView
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        // No need to update the view in this case
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
