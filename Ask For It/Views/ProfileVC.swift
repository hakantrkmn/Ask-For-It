//
//  ProfileVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class ProfileVC: UIViewController {

    private let logoutButton = CustomButton(title: "Logout", hasBackground: true, fontSize: .Big)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI()
    {
        view.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(view).multipliedBy(0.65)
        }
        
        logoutButton.addTarget(self, action: #selector(logoutbuttonTapped), for: .touchUpInside)
    }
    
    @objc func logoutbuttonTapped()
    {
        AuthService.logoutUser { result in
            switch result {
            case .success(_):
                let vc = LoginVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                break
            case .failure(_):
                print("sıkıntı oldu")
            }
        }
    }

}
