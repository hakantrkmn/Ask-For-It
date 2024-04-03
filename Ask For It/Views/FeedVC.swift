//
//  FeedVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit
class FeedVC: UIViewController {

    var feedTable = UITableView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        feedTable.register(FeedTableCell.self, forCellReuseIdentifier: FeedTableCell.identifier)
        feedTable.dataSource = self
        feedTable.delegate = self
        setupUI()
    }
    
    private func setupUI()
    {
        view.addSubview(feedTable)
        feedTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

    }
    
    @objc func addTapped()
    {
        let vc = CreateQuestionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    


}

extension FeedVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableCell.identifier, for: indexPath) as? FeedTableCell else {return UITableViewCell() }
        cell.set(temp: "hakan")
        
        return cell
    }
    
    
}
