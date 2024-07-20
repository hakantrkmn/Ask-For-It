//
//  ProfileVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class ProfileVC: UIViewController 
{
    
    var profileSummary = ProfileSummaryView(with: UserInfo.shared.user)
    
    var segment = UISegmentedControl(items: ["Created Questions","Answered Questions"])
    var pageView = ProfileQuestionPageVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureUI()
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logoutTapped))
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
        
    }
    
    @objc func logoutTapped()
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
    
    
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl)
    {
        pageView.changePage(index: segmentedControl.selectedSegmentIndex)
    }
    
    func configureUI()
    {
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
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


