//
//  SearchUserTableCell.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 27.07.2024.
//

import UIKit

class SearchUserTableCell: UICollectionViewCell {
    
    static let identifier = "SearchUserTableCell"
    var user : User? = nil
    
    var usernameLabel =  UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubViews(usernameLabel)
        
        usernameLabel.textAlignment = .center
        usernameLabel.font = .boldSystemFont(ofSize: 20)
        usernameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func set()
    {
        usernameLabel.text = user?.username
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
