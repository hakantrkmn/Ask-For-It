//
//  OptionsTableCell.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 2.04.2024.
//

import UIKit

class OptionsTableCell: UITableViewCell {

    public static let identifier = "OptionsTableCell"
    var option = UITextField()
    
    
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
        option.placeholder = "New Option"
        
        
    }
    
    
    
    private func setupCell()
    {
        contentView.addSubview(option)
        option.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
            
        }
        contentView.isUserInteractionEnabled = true
        option.autocorrectionType = .no
        
        option.layer.borderWidth = 1
        option.layer.cornerRadius = 18
        option.textAlignment = .center
        option.clipsToBounds = true
        option.layer.borderColor = UIColor.systemBackground.inverted.cgColor

        selectionStyle = .none
        option.font = .systemFont(ofSize: 20)
    }
    
    

}
