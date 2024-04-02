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
    private var usernameLabel = CustomTextField(fieldType: .username)
    private var passwordLabel = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .Big)
    private let newUserButton = CustomButton(title: "Create Account", hasBackground: false, fontSize: .Medium)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        self.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(newUserButtonTapped), for: .touchUpInside)
        
        let user = LoginUserRequest(email: "hakan@gmail.com", password: "hakan6161")
        
        AuthService.loginUser(with: user) { result in
            switch result {
            case .success(_):
                AlertManager.showInvalidEmailAlert(on: self)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
  
    @objc func signInButtonTapped()
    {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func newUserButtonTapped()
    {
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    private func setupUI()
    {
        view.addSubViews(header,usernameLabel,passwordLabel,signInButton,newUserButton)
        
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
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(12)
            make.centerX.equalTo(header)
            make.height.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
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
