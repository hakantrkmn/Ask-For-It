//
//  CreatedQuestionsView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit
import SnapKit

class CreatedQuestionsVC: SpinnerBase
{
    var questions : [Question]?
    var questionsTable = UITableView()
    var user : User?
    var emptyText = WarningLabel(title: "Opps... There is no created question")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        questionsTable.delegate = self
        questionsTable.dataSource = self
    }
   
    override func viewWillAppear(_ animated: Bool) {
        configure(with: user!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityIndicatorEnd()

    }
    
    
    func configure(with user : User)
    {
        emptyText.isHidden = true
        Task{
            self.activityIndicatorBegin()

            do{
                questions = try await NetworkService.shared.getUserCreatedQuestions(with: user)
                emptyText.isHidden = !questions!.isEmpty
                questionsTable.reloadData()
                self.activityIndicatorEnd()
            }
            catch{
                emptyText.isHidden = false
                self.activityIndicatorEnd()

            }
        }
        
    }
    
    func setUI()
    {
        view.addSubViews(questionsTable,emptyText)
        
        questionsTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyText.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}
extension CreatedQuestionsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        guard let question = questions else { return UITableViewCell()}

        cell!.textLabel?.text = question[indexPath.row].title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserInfo.shared.user.createdQuestionID!.contains(questions![indexPath.row].option.first!.questionID)
        {
            let vc = QuestionDetailVC()
            vc.vm.questionID = questions![indexPath.row].option.first!.questionID
            navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = AnswerQuestionVC()
            vc.vm.questionId = questions![indexPath.row].option.first!.questionID
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
