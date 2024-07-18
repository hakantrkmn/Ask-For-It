//
//  ChartView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit
import DGCharts

class ChartView: PieChartView {

    var numberofDownloadEntry = [PieChartDataEntry]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawHoleEnabled = false
        usePercentValuesEnabled = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with question : Question)
    {
        for i in 0..<question.option.count
        {
            let data = PieChartDataEntry(value: Double(question.option[i].votedUserID.count))
            
            data.label = question.option[i].title
            
            numberofDownloadEntry.append(data)
        }
        
        centerText = question.title
        
        
        
        let charSet = PieChartDataSet(entries: numberofDownloadEntry , label: "hakan")
        
        let charData = PieChartData(dataSet: charSet)
       
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.multiplier = 1.0
        numberFormatter.percentSymbol = "%"
        numberFormatter.zeroSymbol = ""
       
        let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
        charData.setValueFormatter(valuesNumberFormatter)
        
        
        charSet.colors = ChartColorTemplates.colorful()
        
        data = charData
        
    }
}

class ChartValueFormatter: NSObject, ValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?

    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}
