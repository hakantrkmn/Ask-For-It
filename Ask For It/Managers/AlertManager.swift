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
    public static func showBasicAlert(on vc : UIViewController,title : String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        vc.present(alert, animated: true)
    }
}


extension AlertManager
{
    // MARK: Auth Alerts
    public static func showInvalidEmailAlert(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please check your email")
    }
    
    public static func showInvalidPasswordAlert(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please check your password")
    }
    
    public static func showInvalidUsernameAlert(on vc : UIViewController)
    {
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please check your username")
    }
}
