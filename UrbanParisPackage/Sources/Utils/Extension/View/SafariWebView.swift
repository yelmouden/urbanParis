//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 26/07/2024.
//

import SwiftUI
import SafariServices

public struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {

    }
}
