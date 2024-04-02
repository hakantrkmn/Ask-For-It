//
//  CustomTextField.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit

class CustomTextField: UITextField 
{
    enum CustomTextFieldType : String
    {
        case username = "Username"
        case password = "Password"
        case email = "Email"
    }
    
    private let authFieldType : CustomTextFieldType
    
    init(fieldType : CustomTextFieldType )
    {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.placeholder = self.authFieldType.rawValue

        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        switch self.authFieldType {
        case .username:
            break
        case .password:
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .email:
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)

        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    
    required init?(coder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
}
