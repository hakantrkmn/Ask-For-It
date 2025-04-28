//
//  QuestionDetailVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import UIKit
import DGCharts
import SnapKit

class QuestionDetailVC: UIViewController
{
    
    var vm = QuestionDetailViewModel()
    
    let questionTitle = UILabel()
    let optionStack = UIStackView()
    
    var chartView = ChartView()
    var votedUserAmount = UILabel()
    var createdUser = UILabel()
    var detailedAnswerView = DetailedAnswerView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground
        setUI()
        configure()
        
        Task{
            try await vm.getQuestion()
            if vm.question?.createdUserID == UserInfo.shared.user.id
            {
                detailedAnswerView.question = vm.question
                detailedAnswerView.configure()
            }
            else
            {
                detailedAnswerView.isHidden = true
            }
            configure()
            
        }
        
        detailedAnswerView.delegate = self
        
        var shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(addTapped))
        shareButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = shareButton
        
    }
    
    @objc func addTapped()
    {
        guard let url = URL(string: "askforit://details?id=\(vm.questionID)") else {
                return
            }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
    }
    
    func configure()
    {
        guard let question = vm.question else {return}
        chartView.configure(with: question)
        votedUserAmount.text = "\(question.answeredUserID.count) people voted"
        votedUserAmount.textAlignment = .center
        //createdUser.text = question.createdUserInfo?.username
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        createdUser.isUserInteractionEnabled = true
        
        createdUser.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped()
    {
        
        let vc = VisitProfileVC()
        vc.vm.userID = vm.question!.createdUserID
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setUI()
    {
        view.addSubViews(chartView,votedUserAmount,createdUser,detailedAnswerView)
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(view.frame.height/3)
        }
        
        votedUserAmount.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom)
            make.leading.trailing.equalTo(view)
            
        }
        
        createdUser.snp.makeConstraints { make in
            make.top.equalTo(votedUserAmount.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        detailedAnswerView.snp.makeConstraints { make in
            make.top.equalTo(createdUser.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(view.frame.width / 8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
    
    
    
}

extension QuestionDetailVC : DetailedAnswerDelegate
{
    func usernameTapped(userID: String) {
        let vc = VisitProfileVC()
        vc.vm.userID =  userID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
