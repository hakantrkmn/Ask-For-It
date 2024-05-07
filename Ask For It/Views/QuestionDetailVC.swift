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
    
    var pieChart = PieChartView()
    
    var iosData = PieChartDataEntry(value: 10)
    var macData = PieChartDataEntry(value: 15)
    var numberofDownloadEntry = [PieChartDataEntry]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Task
        {
            do{
                try await vm.getQuestion(with: "asd")
                dump(vm.question)
                
                for i in 0..<vm.question!.options.count
                {
                    var data = PieChartDataEntry(value: Double(vm.question!.options[i].userIDs.count))
                    data.label = vm.question!.options[i].title
                    numberofDownloadEntry.append(data)
                }
                
                pieChart.drawHoleEnabled = false
                pieChart.usePercentValuesEnabled = true
                pieChart.centerText = vm.question!.title
                
                let charSet = PieChartDataSet(entries: numberofDownloadEntry , label: "hakan")
                let charData = PieChartData(dataSet: charSet)
                
                for i in 0..<vm.question!.options.count
                {
                    let color = UIColor.random
                    
                    charSet.colors.append(color)
                }
               
                
                pieChart.data = charData
            }
            catch
            {
                print(error)
            }
        }
        view.backgroundColor = .systemBackground
        view.addSubview(pieChart)
        pieChart.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
       

        
    }



}
