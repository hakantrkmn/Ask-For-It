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
    func imageTapped()
    
}

class ProfileSummaryView: UIView
{
    weak var delegate: ProfileSummaryDelegate?
    
    let imagePicker = UIImagePickerController()
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
    
    
    
    @objc func imageTapped() {
        delegate?.imageTapped()
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
        
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = false
        self.imagePicker.mediaTypes = ["public.image"]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(followedLabelTapped))
        followedAmountLabel.isUserInteractionEnabled = true
        
        followedAmountLabel.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(followingLabelTapped))
        followingAmountLabel.isUserInteractionEnabled = true
        
        followingAmountLabel.addGestureRecognizer(tapGesture2)
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        ppImageView.isUserInteractionEnabled = true
        ppImageView.contentMode = .scaleAspectFill
        ppImageView.addGestureRecognizer(imageTapGesture)
        
        
        
        
    }
    func set(with user : User)
    {
        DispatchQueue.main.async
        {
            self.usernameLabel.text = user.username
            self.followedAmountLabel.text = "\(user.followedUserID.count) Follow"
            self.followingAmountLabel.text = "\(user.followingUserID.count) Following"
        }
        
        NetworkService.shared.downloadUserPhoto(userID: user.id) { image in
            DispatchQueue.main.async
            {
                if image == nil {
                    self.ppImageView.image = UIImage(named: "logo")
                } else {
                    self.ppImageView.image = image
                }
            }
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

extension ProfileSummaryView : UIImagePickerControllerDelegate ,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("kanslşdknals")
        if info[.mediaType] as? String == "public.image"
        {
            var image = info[.originalImage] as? UIImage
            NetworkService.shared.uploadUserPhoto(image: image!)
            ppImageView.image = image
        }
        
        imagePicker.dismiss(animated: true)
    }
}
