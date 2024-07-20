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
    func signIn(with user : LoginUserRequest , for vc : UIViewController) async throws
    {
        if Validator.isValidEmail(for: user.email)
        {
            
                let user = LoginUserRequest(email: user.email, password: user.password)
                
                    try await AuthService.loginUser(with: user)
                    
                    guard let id = Auth.auth().currentUser?.uid else {return }
                    
                    UserInfo.shared.user = try await NetworkService.shared.getUserInfo(with: id)
                    
                   
           
        }
        else
        {
            await AlertManager.showInvalidEmailAlert(on: vc)
        }
        
    }
}
