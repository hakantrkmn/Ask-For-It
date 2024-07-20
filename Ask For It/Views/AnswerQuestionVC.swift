//
//  AnswerQuestionVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import UIKit
import SnapKit


class AnswerQuestionVC: SpinnerBase
{
    
    var vm = AnswerQuestionViewModel()
    
    let questionTitle = UILabel()
    let optionsTable = UITableView()
    
    let answerButton = UIButton()
    var previouslySelectedIndexPath: IndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
        configureUI()
        
        title = "Answer"
        
        Task{
            self.activityIndicatorBegin()
            
            do{
                try await vm.getQuestion()
                questionTitle.text = vm.question?.title
                optionsTable.reloadData()
                answerButton.isHidden = false
                self.activityIndicatorEnd()
            }
            catch
            {
                self.activityIndicatorEnd()
                
            }
        }
        
        
    }
    
    func configureUI()
    {
        optionsTable.delegate = self
        optionsTable.dataSource = self
        optionsTable.register(AnswerQuestionTableCell.self, forCellReuseIdentifier: AnswerQuestionTableCell.identifier)
        optionsTable.separatorStyle = .none
        
        questionTitle.font = .systemFont(ofSize: 25)
        questionTitle.textAlignment = .center
        answerButton.setTitle("Answer", for: .normal)
        answerButton.setTitleColor(.white, for: .normal)
        answerButton.backgroundColor = .systemBlue
        answerButton.layer.cornerRadius = 15
        
        answerButton.isHidden = true
        answerButton.addTarget(self, action: #selector(answerTapped), for: .touchUpInside)
        
        optionsTable.separatorStyle = .none
    }
    
    @objc func answerTapped()
    {
        guard let index = optionsTable.indexPathForSelectedRow?.row else {return}
        self.activityIndicatorBegin()
        Task
        {
            do{
                try await vm.answerQuestion(index:  index)
                let vc = QuestionDetailVC()
                vc.vm.questionID = vm.question!.option.first!.questionID
                self.activityIndicatorEnd()
                
                UserInfo.shared.user.answeredQuestionID!.append(vm.question!.option.first!.questionID)
                navigationController?.popViewController(animated: true)
                navigationController?.pushViewController(vc, animated: true)
            }
            catch{
                self.activityIndicatorEnd()
                AlertManager.showAnswerFailed(on: self)
            }
            
        }
    }
    
    func setUI()
    {
        view.addSubViews(questionTitle,optionsTable,answerButton)
        
        questionTitle.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(-view.frame.height / 4)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        optionsTable.snp.makeConstraints { make in
            make.top.equalTo(questionTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(80)
            make.height.equalTo(200)
        }
        
        answerButton.snp.makeConstraints { make in
            make.top.equalTo(optionsTable.snp.bottom).offset(40)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
}


extension AnswerQuestionVC : UITableViewDelegate , UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let previousIndex = previouslySelectedIndexPath else
        {
            let cell = tableView.cellForRow(at: indexPath) as? AnswerQuestionTableCell
            cell?.cellSelected()
            previouslySelectedIndexPath = indexPath
            return
        }
        
        let prevCell = tableView.cellForRow(at: previouslySelectedIndexPath!) as? AnswerQuestionTableCell
        prevCell?.cellDeSelected()
        let cell = tableView.cellForRow(at: indexPath) as? AnswerQuestionTableCell
        cell?.cellSelected()
        previouslySelectedIndexPath = indexPath
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let count = vm.question?.option.count else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerQuestionTableCell.identifier, for: indexPath) as? AnswerQuestionTableCell,
              let option = vm.question?.option[indexPath.row] else { return UITableViewCell()}
        cell.set(temp: option.title)
        cell.frame.size.height = 40
        
        return cell
    }
    
    
}
