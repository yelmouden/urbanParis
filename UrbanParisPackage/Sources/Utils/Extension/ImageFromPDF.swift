//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 22/07/2024.
//

import Foundation
import UIKit

public func imageFromPDF(named pdfName: String, bundle: Bundle) -> UIImage {
    // Obtenir l'URL du PDF dans le bundle
    guard let url = bundle.url(forResource: pdfName, withExtension: "pdf"),
          let pdfDocument = CGPDFDocument(url as CFURL) else {
        fatalError("PDF not found")
    }

    // Vérifier si la page demandée existe
    guard let pdfPage = pdfDocument.page(at: 1) else {
        fatalError("Could not get PDF page")
    }

    // Obtenir le rectangle de la page
    let pageRect = pdfPage.getBoxRect(.mediaBox)

    // Créer un renderer pour dessiner le PDF dans une image
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)

    // Rendre la page PDF en UIImage
    let image = renderer.image { context in
        // Préparer le contexte pour Quartz
        context.cgContext.saveGState()

        // Flip le contexte pour les coordonnées Quartz
        context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        context.cgContext.scaleBy(x: 1.0, y: -1.0)

        // Dessiner la page PDF dans le contexte
        context.cgContext.drawPDFPage(pdfPage)

        // Restaurer l'état du contexte
        context.cgContext.restoreGState()
    }

    return image
}

