//
//  FeedTableCell.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 2.04.2024.
//

import UIKit
import SnapKit

protocol CustomCellDelegate: AnyObject {
    func profileTapped(_ user: String)
}

class FeedTableCell: UITableViewCell {

    public static let identifier = "FeedTableCell"
    var questionTitle = UILabel()
    var createdAtLabel = UILabel()
    var createdUser = UILabel()
    var question : Question?
    
    weak var delegate: CustomCellDelegate?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(usernameTapped))
        createdUser.isUserInteractionEnabled = true

        tapGesture.cancelsTouchesInView = true // Bu satır önemli
        createdUser.addGestureRecognizer(tapGesture)
        questionTitle.numberOfLines = 2
        questionTitle.adjustsFontSizeToFitWidth = true
        questionTitle.minimumScaleFactor = 1
        
    }
    
    @objc func usernameTapped() {
        delegate?.profileTapped(question!.createdUserID)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(question : Question)
    {
        self.question = question
        questionTitle.text = question.title
        createdAtLabel.text = question.createdAt.toString()
        
        var stringOne = "Asked by \(question.createdUserInfo!.username) "
        let stringTwo = question.createdUserInfo!.username

        let range = (stringOne as NSString).range(of: stringTwo)
        print(range)
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue , range: range)
        createdUser.attributedText = attributedText
        
    }
    
    
    
    private func setupCell()
    {
        contentView.addSubViews(questionTitle,createdAtLabel,createdUser)
        
        
        questionTitle.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10)
            make.bottom.equalTo(createdAtLabel.snp.top)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        createdUser.snp.makeConstraints { make in
            make.trailing.equalTo(createdAtLabel.snp.leading)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        
    }
}
