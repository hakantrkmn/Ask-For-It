//
//  QuestionDetailVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import UIKit
import DGCharts
import SnapKit

class QuestionDetailVC: UIViewController {
    
    var vm = QuestionDetailViewModel()
    
    let questionTitle = UILabel()
    let optionStack = UIStackView()
    
    var chartView = ChartView()
    var votedUserAmount = UILabel()
   var createdUser = UILabel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground
        setUI()
        configure()
        
        Task{
            try await vm.getQuestion()
            configure()
            
        }

        
    }
    
    func configure()
    {
        guard let question = vm.question else {return}
        chartView.configure(with: question)
        votedUserAmount.text = "\(question.answeredUserID.count) people voted"
        votedUserAmount.textAlignment = .center
        createdUser.text = question.createdUserInfo?.username
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        createdUser.isUserInteractionEnabled = true

        tapGesture.cancelsTouchesInView = true // Bu satır önemli
        createdUser.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {

            // İkinci view controller'a geçiş
        Task
        {
            do
            {
                var vc = VisitProfileVC()
                vc.user = try await NetworkService.shared.getUserInfo(with:vm.question!.createdUserID)
                navigationController?.pushViewController(vc, animated: true)
            }
            catch let error
            {
                print(error.localizedDescription)
            }
           
        }
        }
    
    func setUI()
    {
        view.addSubViews(chartView,votedUserAmount,createdUser)
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(view.frame.height/3)
        }
        
        votedUserAmount.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom)
            make.leading.trailing.equalTo(votedUserAmount)
            
        }
        
        createdUser.snp.makeConstraints { make in
            make.top.equalTo(votedUserAmount.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
    
}
