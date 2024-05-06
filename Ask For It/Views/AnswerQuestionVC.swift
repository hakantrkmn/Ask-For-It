//
//  AnswerQuestionVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 5.05.2024.
//

import UIKit
import SnapKit


class AnswerQuestionVC: UIViewController
{

    var vm = AnswerQuestionViewModel()
    
    let questionTitle = UILabel()
    let optionsTable = UITableView()
    
    let answerButton = UIButton()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
        configureUI()
    }
    
    func configureUI()
    {
        optionsTable.delegate = self
        optionsTable.dataSource = self
        optionsTable.register(AnswerQuestionTableCell.self, forCellReuseIdentifier: AnswerQuestionTableCell.identifier)
        
        questionTitle.text = vm.question?.title
        
        answerButton.setTitle("Answer", for: .normal)
        answerButton.setTitleColor(.white, for: .normal)
        answerButton.backgroundColor = .systemBlue
        answerButton.layer.cornerRadius = 15
        
        answerButton.addTarget(self, action: #selector(answerTapped), for: .touchUpInside)
        
    }
    
    @objc func answerTapped()
    {
        guard let index = optionsTable.indexPathForSelectedRow?.row else {return}

        Task
        {
            try await vm.answerQuestion(index:  index)

        }
    }
    
    func setUI()
    {
        view.addSubViews(questionTitle,optionsTable,answerButton)
        
        questionTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        optionsTable.snp.makeConstraints { make in
            make.top.equalTo(questionTitle.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(100)
        }
        
        answerButton.snp.makeConstraints { make in
            make.top.equalTo(optionsTable.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(100)
        }
    }
    

    
    


}
extension AnswerQuestionVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = vm.question?.options.count else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerQuestionTableCell.identifier, for: indexPath) as? AnswerQuestionTableCell,
        let option = vm.question?.options[indexPath.row] else { return UITableViewCell()}
        cell.set(temp: option.title)
        return cell
    }
    
    
}
