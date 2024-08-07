//
//  SignInVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit

class RegisterVC: SpinnerBase {
    
    private var header = AuthHeaderView(title: "Sign Up", subTitle: "Create your account")
    private var usernameLabel = CustomTextField(fieldType: .username)
    private var emailLabel = CustomTextField(fieldType: .email)
    private var passwordLabel = CustomTextField(fieldType: .password)
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .Big)
    private let signInButton = CustomButton(title: "Already have an account? Sign in.", hasBackground: false, fontSize: .Small)
    
    let vm = RegisterViewModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        self.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func signUpButtonTapped()
    {
        guard let email = emailLabel.text , let password = passwordLabel.text , let username = usernameLabel.text else {return}
        self.activityIndicatorBegin()
        Task {
            do{
                try await  vm.signUp(for: RegisterUserRequest(username: username, email: email, password: password , followedUserID: [] , followingUserID: []), for: self)
                self.activityIndicatorEnd()
                
            }
            catch let error
            {
                print(error)
                AlertManager.showBasicAlert(on: self, title: "Something Wrong", message: "Wrong Password")
                self.activityIndicatorEnd()
                
                
            }
        }
        
    }
    
    @objc func signInButtonTapped()
    {
        let vc = LoginVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    
    
    private func setupUI()
    {
        view.addSubViews(header,usernameLabel,emailLabel,passwordLabel,signUpButton,signInButton)
        
        header.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(view.safeAreaLayoutGuide )
            make.height.equalTo(200)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
    }
}
