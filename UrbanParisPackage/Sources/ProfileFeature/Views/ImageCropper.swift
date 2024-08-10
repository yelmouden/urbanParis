//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 09/08/2024.
//

import Foundation
import TOCropViewController
import SwiftUI

struct ImageCropper: UIViewControllerRepresentable{
    @Environment(\.presentationMode) var isPresented

  var image: UIImage?
    var imageCropped: Binding<UIImage?>

  class Coordinator: NSObject, TOCropViewControllerDelegate{
    let parent: ImageCropper

    init(_ parent: ImageCropper){
      self.parent = parent
    }

      func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        parent.isPresented.wrappedValue.dismiss()
          let circularImage = circularImage(image: image)
          parent.imageCropped.wrappedValue = circularImage
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        parent.isPresented.wrappedValue.dismiss()

    }
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

  func makeUIViewController(context: Context) -> some UIViewController {
    let img = self.image ?? UIImage()
    let cropViewController = TOCropViewController(image: img)
    cropViewController.delegate = context.coordinator
    return cropViewController
  }
}

import CoreGraphics
import UIKit

func circularImage(image: UIImage) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: 180, height: 180)

    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()

    context?.addEllipse(in: rect)
    context?.clip()

    image.draw(in: rect)

    let circularImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return circularImage
}
