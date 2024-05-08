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
    
   
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
        configure()
        
    }
    
    func configure()
    {
        guard let question = vm.question else {return}
        chartView.configure(with: question)
    }
    
    func setUI()
    {
        view.addSubview(chartView)
        
        chartView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
}
