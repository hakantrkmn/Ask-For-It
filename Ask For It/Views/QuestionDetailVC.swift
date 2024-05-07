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

    let questionTitle = UILabel()
    let optionStack = UIStackView()
    
    var pieChart = PieChartView()
    
    var iosData = PieChartDataEntry(value: 10)
    var macData = PieChartDataEntry(value: 15)
    var numberofDownloadEntry = [PieChartDataEntry]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(pieChart)
        pieChart.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        iosData.label = "iosdata"
        macData.label = "macdata"
        pieChart.drawHoleEnabled = false
        pieChart.usePercentValuesEnabled = true
        pieChart.centerText = "hakan baba"
        numberofDownloadEntry = [iosData,macData]
        
        updateChartData()

        
    }
    
    func updateChartData()
    {
        let charSet = PieChartDataSet(entries: numberofDownloadEntry , label: "hakan")
        let charData = PieChartData(dataSet: charSet)
        
        let color = [UIColor.red,UIColor.green]
        
        charSet.colors = color as! [NSUIColor]
        
        pieChart.data = charData
    }


}
