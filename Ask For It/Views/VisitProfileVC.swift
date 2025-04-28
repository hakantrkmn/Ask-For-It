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
        profileSummary.delegate = self

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
            followButton.tintColor = .systemGreen
            navigationItem.rightBarButtonItem = followButton
        }
        else
        {
            followButton = UIBarButtonItem(title: "Unfollow", style: .plain, target: self, action: #selector(unfollowTapped))
            followButton.tintColor = .systemRed
            navigationItem.rightBarButtonItem = followButton
        }
        
        }

        
    }
    
    
    
    
    @objc func unfollowTapped()
    {
        Task{
            do
            {
                followButton.isEnabled = false

                try await NetworkService.shared.unfollowUser(with: vm.user!.id)
                followButton.title = "Follow"
                followButton.tintColor = .systemGreen
                followButton.action = #selector(followTapped)
                vm.user!.followedUserID.remove(object: UserInfo.shared.user.id)
                dump(vm.user!)
                profileSummary.set(with: vm.user!)
                
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000) // 1 second

                followButton.isEnabled = true

            }
            catch let error
            {
                followButton.isEnabled = true

                print(error)
            }
        }
    }
    @objc func followTapped()
    {

        Task{
            do
            {
                followButton.isEnabled = false

                try await NetworkService.shared.followUser(with: vm.user!.id)
                followButton.title = "Unfollow"
                followButton.tintColor = .systemRed
                followButton.action = #selector(unfollowTapped)
                
                vm.user!.followedUserID.append(UserInfo.shared.user.id)
                dump(vm.user!)

                profileSummary.set(with: vm.user!)
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000) // 1 second

                followButton.isEnabled = true

            }
            catch let error
            {
                followButton.isEnabled = true

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



extension VisitProfileVC : ProfileSummaryDelegate , UserListVCDelegate
{
    func userTapped(userID: String) {
        print("aksdnşkasd")
        let vc = VisitProfileVC()
        vc.vm.userID = userID
        navigationController?.pushViewController(vc, animated: true)
    }
    func imageTapped() {
        
    }
    func followedTapped() {
        let vc = UserListVC()
        vc.user = vm.user
        vc.modalPresentationStyle = .formSheet
        vc.listType = .Followed
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    func followingTapped() {

        let vc = UserListVC()
        vc.user = vm.user
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        vc.listType = .Following
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    
}
