//
//  AuthHeaderView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class AuthHeaderView: UIView
{
    
    private let logoImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26 , weight: .bold)
        label.text = "Error"
        return label
    }()
    
    private let subTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18 , weight: .regular)
        label.text = "Error"
        return label
    }()
    
    init(title : String, subTitle : String)
    {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        setupUI()
        
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI()
    {
        addSubViews(logoImage,titleLabel,subTitleLabel)
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(super.snp.top).offset(16)
            make.centerX.equalTo(super.snp.centerX)
            make.width.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(19)
            make.leading.trailing.equalTo(self)
        }
        
        subTitleLabel
            .snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(self)
        }
        
       
    }
    
    
}
