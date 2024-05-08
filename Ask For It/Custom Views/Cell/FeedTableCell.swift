//
//  FeedTableCell.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 2.04.2024.
//

import UIKit
import SnapKit

class FeedTableCell: UITableViewCell {

    public static let identifier = "FeedTableCell"
    var questionTitle = UILabel()
    var createdAtLabel = UILabel()
    var createdUser = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(question : Question)
    {
        
        questionTitle.text = question.title
        createdAtLabel.text = question.createdAt.toString()
        createdUser.text = question.userInfo?.username
    }
    
    private func setupCell()
    {
        addSubViews(questionTitle,createdAtLabel,createdUser)
        
        questionTitle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
        createdUser.snp.makeConstraints { make in
            make.trailing.equalTo(createdAtLabel.snp.leading)
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
        
    }
}
