//
//  RegisterViewModel.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterViewModel
{
    @MainActor
    func signUp(for user : RegisterUserRequest , for vc : UIViewController) async throws
    {
        if Validator.isValidEmail(for: user.email)
        {
            
            do{
                try await  AuthService.registerUser(with: user)
                guard let id = Auth.auth().currentUser?.uid else {return }
                
                UserInfo.shared.user = try await NetworkService.shared.getUserInfo(with: id)
                
                let feed =  TabBarController()
                feed.modalPresentationStyle = .fullScreen
                vc.present(feed, animated: true)
            }
            catch let error as AuthErrorCode{
                if error.errorCode == 17007
                {
                    AlertManager.emailAlreadyInUse(on: vc)
                }
                else if error.errorCode == 17026
                {
                    AlertManager.showNotGoodPassword(on: vc)
                }
            }
            
            
            
        }
        else
        {
            AlertManager.showInvalidEmailAlert(on: vc)
        }
    }
}
