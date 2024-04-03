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
    }
    
    private func setupCell()
    {
        contentView.addSubview(option)
        
        option.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
