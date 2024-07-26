//
//  FeedVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit
import FirebaseAuth
class FeedVC: SpinnerBase
{
    
    var feedTable = UITableView()
    
    var vm = FeedViewModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        setupUI()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title  = "Browse"
        
    }
    
    
    
    private func configureUI()
    {
        feedTable.register(FeedTableCell.self, forCellReuseIdentifier: FeedTableCell.identifier)
        feedTable.dataSource = self
        feedTable.delegate = self
        self.activityIndicatorBegin()
        vm.getQuestions {
            self.feedTable.reloadData()
            self.activityIndicatorEnd()


        }
        
    }
    
    private func setupUI()
    {
        view.addSubview(feedTable)
        feedTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.sendSubviewToBack(feedTable)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    @objc func addTapped()
    {
        let vc = CreateQuestionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension FeedVC : UITableViewDelegate,UITableViewDataSource,CustomCellDelegate
{
    func profileTapped(_ user: String)
    {        
        let vc = VisitProfileVC()
        vc.vm.userID = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vm.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableCell.identifier, for: indexPath) as? FeedTableCell else {return UITableViewCell() }
        cell.set(  question: vm.questions[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let id = vm.questions[indexPath.row].option.first?.questionID else { return}
        
        let vc = AnswerQuestionVC()
        vc.vm.questionId = id
        navigationController?.pushViewController(vc, animated: true)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}
