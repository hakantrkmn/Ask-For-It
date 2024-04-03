//
//  LoginVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    
    private var header = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    private var emailTextField = CustomTextField(fieldType: .email)
    private var passwordTextField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .Big)
    private let newUserButton = CustomButton(title: "Create Account", hasBackground: false, fontSize: .Medium)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        self.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(newUserButtonTapped), for: .touchUpInside)
        emailTextField.delegate = self
        
        
    }
    
    @objc func signInButtonTapped()
    {
        if Validator.isValidEmail(for: emailTextField.text!)
        {
            let user = LoginUserRequest(email: emailTextField.text!, password: passwordTextField.text!)
            AuthService.loginUser(with: user) { result in
                switch result {
                case .success(_):
                    let vc = TabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                case .failure(let failure):
                    AlertManager.showBasicAlert(on: self, title: "Something Wrong", message: "Wrong Password")
                }
            }
            
        }
        else
        {
            AlertManager.showInvalidEmailAlert(on: self)
        }
        
    }
    
    @objc func newUserButtonTapped()
    {
        navigationController?.pushViewController(RegisterVC(), animated: true)
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

extension LoginVC : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !Validator.isValidEmail(for: emailTextField.text!)
        {
            UIView.animate(withDuration: 0.2)
            {
                self.emailTextField.backgroundColor = .red
            } completion: { isDone in
                if isDone
                {
                    UIView.animate(withDuration: 0.2)
                    {
                        self.emailTextField.backgroundColor = .secondarySystemBackground
                    }
                }
            }
            
        }
        
    }
}
