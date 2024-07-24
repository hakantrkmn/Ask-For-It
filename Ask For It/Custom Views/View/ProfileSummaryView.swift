//
//  ProfileSummaryView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit

protocol ProfileSummaryDelegate: AnyObject {
    func followedTapped()
    func followingTapped()
}

class ProfileSummaryView: UIView 
{
    weak var delegate: ProfileSummaryDelegate?

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
    
    var followingAmountLabel : UILabel =
    {
       var label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var followedAmountLabel : UILabel =
    {
       var label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    init(with user : User)
    {
        super.init(frame: .zero)
        setupUI()
        set(with: user)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followedLabelTapped))
        followedAmountLabel.isUserInteractionEnabled = true

        followedAmountLabel.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(followingLabelTapped))
        followingAmountLabel.isUserInteractionEnabled = true

        followingAmountLabel.addGestureRecognizer(tapGesture2)
        
    }
    
    @objc func followedLabelTapped() {
        delegate?.followedTapped()
        }
    
    @objc func followingLabelTapped() {
        delegate?.followingTapped()
        }

    init()
    {
        super.init(frame: .zero)
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followedLabelTapped))
        followedAmountLabel.isUserInteractionEnabled = true

        followedAmountLabel.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(followingLabelTapped))
        followingAmountLabel.isUserInteractionEnabled = true

        followingAmountLabel.addGestureRecognizer(tapGesture2)
        
    }
    func set(with user : User)
    {
        DispatchQueue.main.async{
            self.ppImageView.image = UIImage(named: "logo")
            self.usernameLabel.text = user.username
            
            self.followedAmountLabel.text = "\(user.followedUserID.count) Follow"
            self.followingAmountLabel.text = "\(user.followingUserID.count) Following"
        }
        

        
    }
    
    func setupUI()
    {
        addSubViews(ppImageView,usernameLabel,followedAmountLabel,followingAmountLabel)
        
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
        
        followedAmountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(snp.centerX).offset(-5)
            make.top.equalTo(usernameLabel.snp.bottom)
        }
        
        followingAmountLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.centerX).offset(5)
            make.top.equalTo(usernameLabel.snp.bottom)

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
