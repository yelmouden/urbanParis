//
//  SwiftUIView.swift
//  
//
//  Created by Yassin El Mouden on 23/07/2024.
//

import DesignSystem
import PDFKit
import SwiftUI

struct CharteView: View {
    var body: some View {
        MainContainer(padding: 0) {
            VStack {
                PDFKitView(url: Bundle.module.url(forResource: "charte", withExtension: "pdf")!)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(String(localized: "Charte Urban Paris"))
    }
}

private struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        // Creating a new PDFVIew and adding a document to it
        let pdfView = PDFView()
        pdfView.pageShadowsEnabled = false
        pdfView.autoScales = true
        pdfView.document = .init(url: url)
        pdfView.backgroundColor = .clear
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // we will leave this empty as we don't need to update the PDF
    }
}
