//
//  FeedVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit
import FirebaseAuth
class FeedVC: UIViewController {
    
    var feedTable = UITableView()
    
    var vm = FeedViewModel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        setupUI()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title  = UserInfo.shared.user.username
    }
    
    private func configureUI()
    {
        feedTable.register(FeedTableCell.self, forCellReuseIdentifier: FeedTableCell.identifier)
        feedTable.dataSource = self
        feedTable.delegate = self
     
        
        
        Task
        {
            do
            {
                try await vm.getQuestions()
            }
            catch
            {
                print(Auth.auth().currentUser?.uid ?? "id yok ")
            }
            feedTable.reloadData()
            
        }
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
        return vm.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableCell.identifier, for: indexPath) as? FeedTableCell else {return UITableViewCell() }
        cell.set(temp: vm.questions[indexPath.row].title)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = vm.questions[indexPath.row].options.first?.questionId else { return}
        
        Task{
            do
            {
                
                let vc = AnswerQuestionVC()
                try await vc.vm.getQuestion(with: id)
                navigationController?.pushViewController(vc, animated: true)
            }
            catch
            {
                AlertManager.showQuestionCreationFailed(on: self)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
    
    
    
}
