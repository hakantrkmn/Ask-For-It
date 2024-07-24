//
//  ProfileVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class VisitProfileVC: UIViewController 
{
    
    var user : User?
    var profileSummary = ProfileSummaryView()
    
    var segment = UISegmentedControl(items: ["Created Questions"])
    var pageView = CreatedQuestionsVC()
    
    var followButton = UIBarButtonItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pageView.user = user!
        setupUI()
        configureUI()
        profileSummary.set(with: user!)
        pageView.configure(with: user!)
        
        
        if !UserInfo.shared.user.followingUserID.contains(user!.id)
        {
            followButton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(followTapped))
            navigationItem.rightBarButtonItem = followButton
        }
        else
        {
            followButton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(unfollowTapped))
            navigationItem.rightBarButtonItem = followButton
        }
        
        profileSummary.delegate = self

        
    }
    
    
    @objc func unfollowTapped()
    {
        Task{
            do
            {
                try await NetworkService.shared.unfollowUser(with: user!.id)
                followButton.title = "Follow"
                followButton.tintColor = .systemGreen
                followButton.action = #selector(followTapped)
                user?.followedUserID.remove(object: UserInfo.shared.user.id)
                profileSummary.set(with: user!) 

            }
            catch let error
            {
                print(error)
            }
        }
    }
    @objc func followTapped()
    {
        Task{
            do
            {
                try await NetworkService.shared.followUser(with: user!.id)
                followButton.title = "Unfollow"
                followButton.tintColor = .systemRed
                followButton.action = #selector(unfollowTapped)
                user?.followedUserID.append(UserInfo.shared.user.id)
                profileSummary.set(with: user!)
                 

            }
            catch let error
            {
                print(error)
            }
        }
    }
    
    func configureUI()
    {
        segment.selectedSegmentIndex = 0
        segment.applyWhiteBackgroundColor()
        segment.selectedSegmentTintColor = .systemGray6
    }
    
    private func setupUI()
    {
        view.addSubViews(profileSummary,segment,pageView.view)
        
        profileSummary.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        segment.snp.makeConstraints { make in
            make.top.equalTo(profileSummary.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pageView.view.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(200)
        }
        
        addChild(pageView)
        pageView.didMove(toParent: self)
        
    }
    
    
    
}



extension VisitProfileVC : ProfileSummaryDelegate
{
    func followerTapped() {
        print("klsandşkas")
        let vc = UserListVC()
        vc.user = user
        vc.modalPresentationStyle = .formSheet
        vc.listType = .Following
        present(vc, animated: true)
    }
    
    func followingTapped() {
        let vc = UserListVC()
        vc.user = user
        vc.modalPresentationStyle = .formSheet
        vc.listType = .Followed
        present(vc, animated: true)

    }
    
    
}
