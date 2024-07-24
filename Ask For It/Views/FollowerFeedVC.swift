//
//  FollowerFeedVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 24.07.2024.
//

import UIKit

class FollowerFeedVC: UIViewController {

    var feedTable = UITableView()
    
    var vm = FollowerFeedViewModel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        setupUI()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title  = "Follower Feed"
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFollowingUserIDChange), name: .userInfoChanged, object: nil)

    }
    
    @objc func handleFollowingUserIDChange() {
           // Burada, followingUserID değiştiğinde yapılacak işlemleri belirleyebilirsin.
        vm.getQuestions {
            self.feedTable.reloadData()
        }
       }
       
       deinit {
           NotificationCenter.default.removeObserver(self, name: .userInfoChanged, object: nil)
       }
    
    
    
    private func configureUI()
    {
        feedTable.register(FeedTableCell.self, forCellReuseIdentifier: FeedTableCell.identifier)
        feedTable.dataSource = self
        feedTable.delegate = self
        
        vm.getQuestions {
            self.feedTable.reloadData()
        }
        
    }
    
    private func setupUI()
    {
        view.addSubview(feedTable)
        feedTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ask", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    @objc func addTapped()
    {
        let vc = CreateQuestionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension FollowerFeedVC : UITableViewDelegate,UITableViewDataSource,CustomCellDelegate
{
    func profileTapped(_ user: String)
    {
        Task
        {
            do
            {
                print(user)
                let vc = VisitProfileVC()
                vc.user = try await NetworkService.shared.getUserInfo(with: user)
                navigationController?.pushViewController(vc, animated: true)
            }
            catch
            {
                print("kalnsdşkasd")
            }
            
        }
        
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
