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
    
    
    
   
    var dataSource : UITableViewDiffableDataSource<Section,Option>!
    
    
    var textFieldArray = [UITextView()]
    var allTextInputs : [Option] = [Option(title: "hakan")]
    
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
        //optionsTable.dataSource = self
        optionsTable.delegate = self
        optionsTable.register(OptionsTableCell.self, forCellReuseIdentifier: OptionsTableCell.identifier)
        
        dataSource = UITableViewDiffableDataSource(tableView: optionsTable, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableCell.identifier, for: indexPath) as? OptionsTableCell else {return UITableViewCell()}
            cell.set(temp: itemIdentifier.title)
            cell.contentView.isUserInteractionEnabled = false
            return cell
        })
        
        appendItemToDataSource()
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
                        allTextInputs.append(Option(title: text))
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
        
        
        let newItem = "ali" 
        allTextInputs.append(Option(title: newItem))
        
        appendItemToDataSource()
        //            // Update table view
        //            let newRowIndexPath = IndexPath(row: allTextInputs.count - 1, section: 0)
        //            optionsTable.beginUpdates()
        //
        //            optionsTable.insertRows(at: [newRowIndexPath], with: .fade)
        //
        //            // Scroll to the newly added row
        //            //optionsTable.scrollToRow(at: newRowIndexPath, at: .bottom, animated: true)
        //            for i in 0..<allTextInputs.count-1
        //            {
        //                (optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).contentView.isUserInteractionEnabled = true
        //            }
        //            optionsTable.endUpdates()
        //            //optionsTable.reloadData()
        //
        //        // Update data source
        
    }
    
    func appendItemToDataSource()
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Option>()
        snapshot.appendSections([.first])
        snapshot.appendItems(allTextInputs)
                dataSource.apply(snapshot,animatingDifferences: true)
        
        for i in 0..<allTextInputs.count-1
        {
            print((optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).option.text)
            (optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).contentView.isUserInteractionEnabled = true
        }
    }
    
    func deleteItemFromDataSource(item : Option)
    {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
                dataSource.apply(snapshot,animatingDifferences: true)
        allTextInputs.removeAll(where: {$0.id == item.id})
        
//        for i in 0..<allTextInputs.count-1
//        {
//            print((optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).option.text)
//            (optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).contentView.isUserInteractionEnabled = true
//        }
    }
    
}

extension CreateQuestionVC : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    


   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == allTextInputs.count - 1
        {
            //updateTexts()
            addNewRow()
            
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
                self.deleteItemFromDataSource(item: self.dataSource.itemIdentifier(for: indexPath)!)
               }
               deleteAction.backgroundColor = .red
               let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
               configuration.performsFirstActionWithFullSwipe = true
               return configuration
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteItemFromDataSource(item: dataSource.itemIdentifier(for: indexPath)!)
            
        }
    }
    
    
    
    
}
