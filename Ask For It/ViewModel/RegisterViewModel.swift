//
//  RegisterViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation
import UIKit

class RegisterViewModel
{
    
    func signUp(for user : RegisterUserRequest , for vc : UIViewController)
    {
        if Validator.isValidEmail(for: user.email)
        {
            Task
            {@MainActor in
                do
                {
                    try await  AuthService.registerUser(with: user)
                    let feed = TabBarController()
                    feed.modalPresentationStyle = .fullScreen
                    vc.present(feed, animated: true)
                }
                catch
                {
                    AlertManager.showBasicAlert(on: vc, title: "Something Wrong", message: "Wrong Password")
                    
                }
            }
        }
        else
        {
            AlertManager.showInvalidEmailAlert(on: vc)
        }
    }
}
