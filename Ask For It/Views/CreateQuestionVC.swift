//
//  CreateQuestionVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 2.04.2024.
//

import UIKit
import SnapKit


class CreateQuestionVC: SpinnerBase
{
    var questionText = UITextView()
    var optionsTable = UITableView()
    
    var createButton = CustomButton(title: "Ask", hasBackground: true, fontSize: .Big)
    var addButton = UIButton()
    
    let vm = CreateQuestionViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Ask For It"
        view.backgroundColor = .systemBackground
        optionsTable.delegate = self
        questionText.delegate = self
        optionsTable.register(OptionsTableCell.self, forCellReuseIdentifier: OptionsTableCell.identifier)
        
        vm.dataSource = UITableViewDiffableDataSource(tableView: optionsTable, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableCell.identifier, for: indexPath) as? OptionsTableCell else {return UITableViewCell()}
            cell.set(temp: itemIdentifier.title)
            return cell
        })
        
        vm.appendItemToDataSource()
        setUI()
        configureUI()
    }
    
    
    func setUI()
    {
        view.addSubViews(questionText,optionsTable,createButton,addButton)
        
        questionText.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(-view.frame.height / 4)
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.8)
            make.height.equalTo(90)
            make.centerX.equalToSuperview()
        }
        
        optionsTable.snp.makeConstraints { make in
            make.top.equalTo(questionText.snp.bottom).offset(30)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(220)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(optionsTable.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(createButton)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.trailing.equalTo(optionsTable)
        }
        
        
    }
    
    func configureUI()
    {
        questionText.autocorrectionType = .no
        
        questionText.layer.borderWidth = 1
        questionText.layer.borderColor = UIColor.systemBlue.cgColor
        questionText.font = .systemFont(ofSize: 20)
        questionText.text = "Your Question"
        questionText.textColor = .lightGray
        createButton.addTarget(self, action: #selector(createQuestion), for: .touchUpInside)
        optionsTable.separatorStyle = .none
        
        addButton.addTarget(self, action: #selector(addOption), for: .touchUpInside)
        addButton.setImage(UIImage(systemName: "plus")?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
        addButton.backgroundColor = .systemGreen
        addButton.layer.cornerRadius = 20
        
        
    }
    @objc func addOption()
    {
        if vm.options.count != 5
        {
            vm.addNewRow()
            (optionsTable.cellForRow(at: IndexPath(row: vm.options.count-1, section: 0)) as! OptionsTableCell).option.becomeFirstResponder()
        }
    }
    @objc func createQuestion()
    {
        self.activityIndicatorBegin()
        Task
        {
            do
            {
                try await vm.createQuestion(with: optionsTable, question: questionText.text)
                let vc = QuestionDetailVC()
                vc.vm.questionID = vm.questionId!
                UserInfo.shared.user.createdQuestionID?.append(vm.questionId!)
                navigationController?.pushViewController(vc, animated: true)
                
                self.activityIndicatorEnd()
                
            }
            catch
            {
                AlertManager.showQuestionCreationFailed(on: self)
                self.activityIndicatorEnd()
                
            }
        }
    }

}

extension CreateQuestionVC : UITableViewDelegate , UITextViewDelegate
{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if questionText.text == "Your Question"
        {
            questionText.text = ""
        }
        questionText.textColor = .systemBackground.inverted
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if vm.options.count != 1
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
        else
        {
            return UISwipeActionsConfiguration(actions: [])
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if (editingStyle == .delete)
        {
            vm.deleteItemFromDataSource(at: indexPath)
            
        }
    }
    
    
    
    
}
