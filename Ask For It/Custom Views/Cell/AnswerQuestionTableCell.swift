//
//  AnswerQuestionTableCell.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import UIKit

class AnswerQuestionTableCell: UITableViewCell {
    
    public static let identifier = "AnswerQuestionTableCell"
    var option = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(temp : String)
    {
        option.text = temp
    }
    
    private func setupCell()
    {
        contentView.addSubview(option)
        option.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
