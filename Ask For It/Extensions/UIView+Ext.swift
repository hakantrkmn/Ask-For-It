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


extension TimeInterval
{
    func toString() -> String
    {
        let time = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: time)
        
    }
}

extension UISegmentedControl {

    func applyWhiteBackgroundColor() {
        // for remove bottom shadow of selected element
        self.selectedSegmentTintColor = selectedSegmentTintColor?.withAlphaComponent(0.99)
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else {
                    return
                }
                for i in 0 ..< (self.numberOfSegments)  {
                    let backgroundSegmentView = self.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}
