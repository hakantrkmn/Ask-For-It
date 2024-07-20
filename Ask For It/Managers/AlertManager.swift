//
//  AlertManager.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import Foundation
import UIKit

class AlertManager
{
    @MainActor public static func showBasicAlert(on vc : UIViewController,title : String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        vc.present(alert, animated: true)
    }
}


extension AlertManager
{
    // MARK: Auth Alerts
    @MainActor public static func showInvalidEmailAlert(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please check your email")
    }
    
    @MainActor public static func showInvalidPasswordAlert(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please check your password")
    }
    
    @MainActor public static func showInvalidUsernameAlert(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please check your username")
    }
    
    @MainActor public static func showNotGoodPassword(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "The password must be 6 characters long or more.", message: "Please check your password")
    }
    
    @MainActor public static func emailAlreadyInUse(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "The email address is already in use by another account.", message: "Please check your email")
    }
}

extension AlertManager
{
    // MARK: Create question Alerts
    @MainActor public static func showQuestionCreationFailed(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Cannot Create Question", message: "Something wrong")
    }
    

    
   
}

extension AlertManager
{
    // MARK: Answer question Alerts
    @MainActor public static func showAnswerFailed(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Cannot Answered", message: "Something wrong")
    }
    

    
   
}
