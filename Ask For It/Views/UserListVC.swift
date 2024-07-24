//
//  UserListVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 24.07.2024.
//

import UIKit
import SnapKit

class UserListVC: SpinnerBase {

    var user : User?
    var listType = UserListType.Followed
    
    var users : [User] = []
    
    var tableView = UITableView()
    
    var emptyLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emptyLabel.isHidden = true
        
        emptyLabel.text = "There is no user"
        emptyLabel.font = .boldSystemFont(ofSize: 25)
        emptyLabel.textAlignment = .center
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
                navigationItem.rightBarButtonItem = dismissButton
            
            
           
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        getUsers()
        
        view.addSubViews(tableView,emptyLabel)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func getUsers()
    {
        self.activityIndicatorBegin()
        Task
        {
            switch listType {
            case .Following:
                for user in user!.followingUserID
                {
                    do
                    {
                        users.append(try await NetworkService.shared.getUserInfo(with: user))
                        tableView.reloadData()
                        dump(users)

                        
                    }
                    catch let error
                    {
                        print(error)
                    }
                }
            case .Followed:
                for user in user!.followedUserID
                {
                    do
                    {
                        users.append(try await NetworkService.shared.getUserInfo(with: user))
                        tableView.reloadData()
                        dump(users)
                    }
                    catch let error
                    {
                        print(error)
                    }
                }
            }
            
            if users.isEmpty
            {
                emptyLabel.isHidden = false
            }
            else
            {
                emptyLabel.isHidden = true

            }
            
            self.activityIndicatorEnd()

        }
        
    }
    

    

}

extension UserListVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
    
    
}

public enum UserListType
{
    case Following
    case Followed
}
