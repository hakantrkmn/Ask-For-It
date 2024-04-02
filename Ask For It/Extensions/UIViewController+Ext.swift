//
//  UIViewController+Ext.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import Foundation
import UIKit
extension UIImageView {
  public func maskCircle(anyImage: UIImage) {
      self.contentMode = .scaleAspectFill
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.masksToBounds = false
    self.clipsToBounds = true

   // make square(* must to make circle),
   // resize(reduce the kilobyte) and
   // fix rotation.
   self.image = anyImage
  }
}
