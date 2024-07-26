//
//  DetailedAnswerView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 20.07.2024.
//

import UIKit

protocol DetailedAnswerDelegate : AnyObject
{
    func usernameTapped(userID : String)
}

class DetailedAnswerView: UIView {

    var question : Question?
    
    var optionsTableStackView = UIStackView()
    
    var tables = [UITableView()]
    
    weak var delegate : DetailedAnswerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI()
    {
        addSubViews(optionsTableStackView)
        
        optionsTableStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure()
    {
        optionsTableStackView.axis = .horizontal
        optionsTableStackView.distribution = .fillEqually
        optionsTableStackView.alignment = .fill
        
        

    

        for _ in 0..<question!.option.count
        {
            let table = UITableView()
            table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            table.layer.borderWidth = 1
            
            optionsTableStackView.addArrangedSubview(table)
            tables.append(table)
            table.separatorStyle = .none
            

            table.dataSource = self
            table.delegate = self
        }
        
        
    }
}
extension DetailedAnswerView : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = tables.firstIndex(of: tableView)
        delegate?.usernameTapped(userID: question!.option[index! - 1].votedUserID[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        let index = tables.firstIndex(of: tableView)
        header.text = question!.option[index! - 1].title
        header.frame.size.height = 50
        
        header.font = .boldSystemFont(ofSize: 20)
        header.textAlignment = .center
        header.textColor = .systemRed
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = tables.firstIndex(of: tableView)
        
        
        return question!.option[index! - 1].votedUserID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let index = tables.firstIndex(of: tableView)
        cell.backgroundColor = .clear
        Task
        {
           
            let sa = try await NetworkService.shared.getUserInfo(with: question!.option[index! - 1].votedUserID[indexPath.row])
            if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                cellToUpdate.textLabel?.text = sa.username
                
                            }
            
        }
        

        return cell
       

    }
    
    
}
