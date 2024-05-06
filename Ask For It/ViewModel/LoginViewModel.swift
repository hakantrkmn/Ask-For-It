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
            let user = LoginUserRequest(email: user.email, password: user.password)
            AuthService.loginUser(with: user) { result in
                switch result 
                {
                case .success(_):
                    Task
                    {
                        guard let id = Auth.auth().currentUser?.uid else {
                            return }
                        UserInfo.shared.user = try await NetworkService.shared.getUserInfo(with: id)
                        
                        DispatchQueue.main.async{
                            let feed = TabBarController()
                            feed.modalPresentationStyle = .fullScreen
                            vc.present(feed, animated: true)
                        }
                    }
                   
                case .failure(_):
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
