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
    
    var createButton = CustomButton(title: "Create", hasBackground: true, fontSize: .Big)
    
    let vm = CreateQuestionViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        optionsTable.delegate = self
        optionsTable.register(OptionsTableCell.self, forCellReuseIdentifier: OptionsTableCell.identifier)
        
        vm.dataSource = UITableViewDiffableDataSource(tableView: optionsTable, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableCell.identifier, for: indexPath) as? OptionsTableCell else {return UITableViewCell()}
            cell.set(temp: itemIdentifier.title)
            cell.contentView.isUserInteractionEnabled = false
            return cell
        })
        
        vm.appendItemToDataSource()
        setUI()
        configureUI()
    }
    
    
    func setUI()
    {
        view.addSubViews(questionText,optionsTable,createButton)
        
        questionText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        optionsTable.snp.makeConstraints { make in
            make.top.equalTo(questionText.snp.bottom).offset(30)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
        
        
    }
    
    func configureUI()
    {
        questionText.layer.borderWidth = 1
        questionText.layer.borderColor = UIColor.red.cgColor
        
        createButton.addTarget(self, action: #selector(createQuestion), for: .touchUpInside)
    }
    
    @objc func createQuestion()
    {
        do
        {
            try vm.createQuestion(with: optionsTable, question: questionText.text)
            Task{
                let vc = AnswerQuestionVC()
                try await vc.vm.getQuestion(with: vm.questionId!)
                navigationController?.pushViewController(vc, animated: true)
            }
           
        }
        catch
        {
            AlertManager.showQuestionCreationFailed(on: self)
        }
    }

    func updateCellInteraction()
    {
        for i in 0..<vm.options.count-1
        {
            (optionsTable.cellForRow(at: IndexPath(row: i, section: 0)) as! OptionsTableCell).contentView.isUserInteractionEnabled = true
        }
    }
    

    
}

extension CreateQuestionVC : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool 
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == vm.options.count - 1
        {
            vm.addNewRow()
            updateCellInteraction()
            (optionsTable.cellForRow(at: indexPath) as! OptionsTableCell).option.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { action, view, handler in
            self.vm.deleteItemFromDataSource(at: indexPath)
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {

        if (editingStyle == .delete)
        {
            vm.deleteItemFromDataSource(at: indexPath)
        }
    }
    
    
    
    
}
