//
//  ProfileVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class ProfileVC: UIViewController {
    
    var profileSummary = ProfileSummaryView(with: UserInfo.shared.user)
    
    var segment = UISegmentedControl(items: ["Created Questions","Answered Questions"])
    var pageView = ProfileQuestionPageVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let logoutButton = CustomButton(title: "Logout", hasBackground: true, fontSize: .Big)
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureUI()
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl)
    {
        pageView.changePage(index: segmentedControl.selectedSegmentIndex)
    }
    
    func configureUI()
    {
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        
    }
    
    private func setupUI()
    {
        view.addSubViews(profileSummary,segment,pageView.view,logoutButton)
        
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
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.65)
        }
        
        addChild(pageView)
        pageView.didMove(toParent: self)
        
        logoutButton.addTarget(self, action: #selector(logoutbuttonTapped), for: .touchUpInside)
    }
    
    @objc func logoutbuttonTapped()
    {
        do
        {
            try AuthService.logoutUser()
            let vc = LoginVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        catch{
            print(error)
        }
        
    }
    
}


