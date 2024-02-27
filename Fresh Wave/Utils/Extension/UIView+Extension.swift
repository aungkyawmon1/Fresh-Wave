//
//  UIView+Extension.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import UIKit

extension UIView {
    @IBInspectable var borderColor: UIColor? {
           set {
               layer.borderColor = newValue?.cgColor
           }
           get {
               guard let color = layer.borderColor else {
                   return nil
               }
               return UIColor(cgColor: color)
           }
       }
       
       @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }
       
       @IBInspectable var cornerRadius: CGFloat {
           set {
               layer.cornerRadius = newValue
               clipsToBounds = newValue > 0
           }
           get {
               return layer.cornerRadius
           }
       }
    
    func dropShadow(opacity: Float, radius: CGFloat, width: Int, height: Int) {
          layer.masksToBounds = false
          layer.shadowColor = UIColor.black.cgColor
          layer.shadowOpacity = opacity
          layer.shadowOffset = CGSize(width: width, height: height)
          layer.shadowRadius = radius
          layer.shouldRasterize = true
          layer.rasterizationScale = UIScreen.main.scale
      }
}
