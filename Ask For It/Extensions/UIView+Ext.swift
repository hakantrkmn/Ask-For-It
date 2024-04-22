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




extension UITableView
{
    func getRows()
    {
        for section in 0..<self.numberOfSections {
            for row in 0..<self.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = self.cellForRow(at: indexPath) as? OptionsTableCell {
                    if let text = cell.option.text {
                        //allTextInputs.append(text)
                    }
                }
            }
        }
    }
}

