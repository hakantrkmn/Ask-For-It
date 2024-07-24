//
//  ProfileVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class VisitProfileVC: SpinnerBase
{
    var vm = VisitProfileViewModel()
    var profileSummary = ProfileSummaryView()
    
    var segment = UISegmentedControl(items: ["Created Questions"])
    var pageView = CreatedQuestionsVC()
    
    var followButton = UIBarButtonItem()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        Task
        {
            self.activityIndicatorBegin()
            await vm.getUser()
            self.activityIndicatorEnd()

        guard let user = vm.user else{return}
        pageView.user = user
        setupUI()
        configureUI()
        profileSummary.set(with: user)
        pageView.configure(with: user)
        
        
        if !UserInfo.shared.user.followingUserID.contains(user.id)
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

        
    }
    
    
    
    
    @objc func unfollowTapped()
    {
        Task{
            do
            {

                try await NetworkService.shared.unfollowUser(with: vm.user!.id)
                followButton.title = "Follow"
                followButton.tintColor = .systemGreen
                followButton.action = #selector(followTapped)
                vm.user!.followedUserID.remove(object: UserInfo.shared.user.id)
                dump(vm.user!)
                profileSummary.set(with: vm.user!)

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

                try await NetworkService.shared.followUser(with: vm.user!.id)
                followButton.title = "Unfollow"
                followButton.tintColor = .systemRed
                followButton.action = #selector(unfollowTapped)
                vm.user!.followedUserID.append(UserInfo.shared.user.id)
                dump(vm.user!)

                profileSummary.set(with: vm.user!)
                 

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
    func followedTapped() {
        let vc = UserListVC()
        vc.user = vm.user
        vc.modalPresentationStyle = .formSheet
        vc.listType = .Followed
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    func followingTapped() {

        let vc = UserListVC()
        vc.user = vm.user
        vc.modalPresentationStyle = .formSheet
        vc.listType = .Following
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    
}
