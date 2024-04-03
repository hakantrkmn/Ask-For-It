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
    var question = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(temp : String)
    {
        question.text = temp
    }
    
    private func setupCell()
    {
        addSubViews(question)
        
        question.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
