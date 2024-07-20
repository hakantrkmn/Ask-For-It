//
//  LoginVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class LoginVC: SpinnerBase 
{
    
    private var header = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    private var emailTextField = CustomTextField(fieldType: .email)
    private var passwordTextField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .Big)
    private let newUserButton = CustomButton(title: "Create Account", hasBackground: false, fontSize: .Medium)
    
    let vm = LoginViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        self.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(newUserButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func signInButtonTapped()
    {
        guard let email = emailTextField.text , let password = passwordTextField.text else {return}
        self.activityIndicatorBegin()
        Task
        {
            do
            {
                try await self.vm.signIn(with: LoginUserRequest(email: email, password: password), for: self)
                self.activityIndicatorEnd()
                let feed = TabBarController()
                feed.modalPresentationStyle = .fullScreen
                self.present(feed, animated: true)
                
            }
            catch let error {
                print(error)
                
                AlertManager.showBasicAlert(on: self, title: "Something Wrong", message: error.localizedDescription)
                self.activityIndicatorEnd()
                
                
            }
        }
        
        
    }
    
    @objc func newUserButtonTapped()
    {
        let vc = RegisterVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func setupUI()
    {
        view.addSubViews(header,emailTextField,passwordTextField,signInButton,newUserButton)
        
        header.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(view.safeAreaLayoutGuide )
            make.height.equalTo(200)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        newUserButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
    }
}

//extension LoginVC : UITextFieldDelegate
//{
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if !Validator.isValidEmail(for: emailTextField.text!)
//        {
//            UIView.animate(withDuration: 0.2)
//            {
//                self.emailTextField.backgroundColor = .red
//            } completion: { isDone in
//                if isDone
//                {
//                    UIView.animate(withDuration: 0.2)
//                    {
//                        self.emailTextField.backgroundColor = .secondarySystemBackground
//                    }
//                }
//            }
//            
//        }
//        
//    }
//}
