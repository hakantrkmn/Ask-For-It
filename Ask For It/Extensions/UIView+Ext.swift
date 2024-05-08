//
//  UIView+Ext.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import Foundation
import UIKit

extension UIView
{
    func addSubViews(_ views : UIView...)
    {
        for view in views
        {
            addSubview(view)
        }
    }
}


extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

extension TimeInterval
{
    func toString() -> String
    {
        let time = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: time)
        
    }
}

