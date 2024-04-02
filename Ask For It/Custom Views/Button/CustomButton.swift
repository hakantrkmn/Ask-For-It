//
//  CustomButton.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit

class CustomButton: UIButton
{
    enum FontSize
    {
        case Big
        case Medium
        case Small
    }
    
    init(title : String, hasBackground : Bool = false , fontSize : FontSize)
    {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.backgroundColor = hasBackground ? .systemBlue : .clear
        self.setTitleColor(hasBackground ? .white : .systemBlue, for: .normal)
        
        switch fontSize 
        {
        case .Big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        case .Medium:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        case .Small:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
