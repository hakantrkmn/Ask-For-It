//
//  LoginViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewModel
{
    func signIn(with user : LoginUserRequest , for vc : UIViewController)
    {
        if Validator.isValidEmail(for: user.email)
        {
            Task
            { @MainActor in
                let user = LoginUserRequest(email: user.email, password: user.password)
                
                do
                {
                    try await AuthService.loginUser(with: user)
                    
                    guard let id = Auth.auth().currentUser?.uid else {return }
                    
                    UserInfo.shared.user = try await NetworkService.shared.getUserInfo(with: id)
                    
                    let feed = TabBarController()
                    feed.modalPresentationStyle = .fullScreen
                    vc.present(feed, animated: true)
                }
                catch
                {
                    dump(error)
                    AlertManager.showBasicAlert(on: vc, title: "Something Wrong", message: error.localizedDescription)
                }
            }
        }
        else
        {
            AlertManager.showInvalidEmailAlert(on: vc)
        }
        
    }
}
