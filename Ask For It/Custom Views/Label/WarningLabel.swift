//
//  WarningLabel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 24.07.2024.
//

import UIKit

class WarningLabel: UILabel {

    
    init(title : String) {
        super.init(frame: .zero)
        text = title
        font = .boldSystemFont(ofSize: 25)
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
