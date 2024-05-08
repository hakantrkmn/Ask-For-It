//
//  ProfileSummaryView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit

class ProfileSummaryView: UIView 
{
    var ppImageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 100
        view.layer.borderWidth = 1
        return view
    }()
    
    
    var usernameLabel : UILabel =
    {
       var label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    init(with user : User)
    {
        super.init(frame: .zero)
        setupUI()
        set(with: user)
        
    }

    func set(with user : User)
    {
        ppImageView.image = UIImage(named: "logo")
        usernameLabel.text = user.username
    }
    
    func setupUI()
    {
        addSubViews(ppImageView,usernameLabel)
        
        ppImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(ppImageView.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
