//
//  CreateQuestionVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 2.04.2024.
//

import UIKit
import SnapKit


class CreateQuestionVC: UIViewController
{
    var questionText = UITextView()
    
    var optionsTable = UITableView()
    
    var textFieldArray = [UITextView()]
    var allTextInputs : [String] = ["hakan"]
    
    var btn = CustomButton(title: "addOption", hasBackground: true, fontSize: .Big)
    
    var cellCount = 1 {
        didSet
        {
            updateTable()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        optionsTable.dataSource = self
        optionsTable.delegate = self
        optionsTable.register(OptionsTableCell.self, forCellReuseIdentifier: OptionsTableCell.identifier)
        setUI()
    }
    
    
    func setUI()
    {
        view.addSubViews(questionText,optionsTable,btn)
        
        questionText.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        optionsTable.snp.makeConstraints { make in
            make.top.equalTo(questionText.snp.bottom).offset(30)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        btn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
        
        btn.addTarget(self, action: #selector(addOption), for: .touchUpInside)
        
    }
    
    @objc func addOption()
    {
        
        allTextInputs.removeAll()
    
        for section in 0..<optionsTable.numberOfSections {
            for row in 0..<optionsTable.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = optionsTable.cellForRow(at: indexPath) as? OptionsTableCell {
                    if let text = cell.option.text {
                        allTextInputs.append(text)
                    }
                }
            }
        }
        
        print("All text inputs: \(allTextInputs)")
        
    }
    func updateTexts()
    {
        allTextInputs.removeAll() // Clear the array before retrieving text inputs

        // Iterate through all cells in the table view
        for section in 0..<optionsTable.numberOfSections {
            for row in 0..<optionsTable.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = optionsTable.cellForRow(at: indexPath) as? OptionsTableCell {
                    if let text = cell.option.text {
                        allTextInputs.append(text)
                    }
                }
            }
        }
        
        // Process or store the text inputs as needed
        print("All text inputs: \(allTextInputs)")
    }
    func updateTable()
    {
        DispatchQueue.main.async{
            self.optionsTable.reloadData()
        }
    }
    func addNewRow() {
        
       
            let newItem = ""
            allTextInputs.append(newItem)
            
            // Update table view
            let newRowIndexPath = IndexPath(row: allTextInputs.count - 1, section: 0)
            optionsTable.beginUpdates()
        
            optionsTable.insertRows(at: [newRowIndexPath], with: .fade)
            
            // Scroll to the newly added row
            //optionsTable.scrollToRow(at: newRowIndexPath, at: .bottom, animated: true)
            for i in 0..<allTextInputs.count-1
            {
                (optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).contentView.isUserInteractionEnabled = true
            }
            optionsTable.endUpdates()
            //optionsTable.reloadData()
                
        // Update data source
        
    }

}

extension CreateQuestionVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
           return true
       }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTextInputs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableCell.identifier, for: indexPath) as? OptionsTableCell else {return UITableViewCell()}
        
        cell.set(temp: allTextInputs[indexPath.row])
        cell.contentView.isUserInteractionEnabled = false
        if indexPath.row == allTextInputs.count - 1
        {
            // cell.contentView.isUserInteractionEnabled = false
            
        }
        else
        {
            // cell.contentView.isUserInteractionEnabled = true
            
            
        }
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == allTextInputs.count - 1
        {
            updateTexts()
            addNewRow()
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            DispatchQueue.main.async{
               // guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableCell.identifier, for: indexPath) as? OptionsTableCell else {return }
                
                self.allTextInputs.remove(at: indexPath.row)
                self.optionsTable.deleteRows(at: [indexPath], with: .fade)
               
                self.optionsTable.reloadData()
                for i in 0..<self.allTextInputs.count-1
                {
                    (self.optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).contentView.isUserInteractionEnabled = true
                }
                
            }
            
        }
    }
    
    
    
    
}
