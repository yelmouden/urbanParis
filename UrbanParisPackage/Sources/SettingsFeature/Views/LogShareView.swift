//
//  LogShareView.swift
//  UrbanParisPackage
//
//  Created by Yassin El Mouden on 20/07/2025.
//

import SwiftUI
import UIKit

struct LogShareView: UIViewControllerRepresentable {
    let fileURL: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
