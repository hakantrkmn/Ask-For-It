//
//  ProfileVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit

class VisitProfileVC: UIViewController {
    
    var user : User?
    var profileSummary = ProfileSummaryView()
    
    var segment = UISegmentedControl(items: ["Created Questions"])
    var pageView = CreatedQuestionsVC()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        pageView.user = user!
        setupUI()
        configureUI()
        profileSummary.set(with: user!)
        pageView.configure(with: user!)
        dump(user)
    }
    
    
    
    func configureUI()
    {
        segment.selectedSegmentIndex = 0
        
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


