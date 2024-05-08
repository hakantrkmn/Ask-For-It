//
//  CreatedQuestionsView.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit
import SnapKit

class CreatedQuestionsVC: UIViewController
{
    var questions : [Question]?
    var questionsTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        questionsTable.delegate = self
        questionsTable.dataSource = self
    }
   
    
    func configure(with user : User)
    {
        Task{
            
            do{
                questions = try await NetworkService.shared.getUserCreatedQuestions(with: user)
                questionsTable.reloadData()
            }
            catch{
                
            }
        }
        
    }
    
    func setUI()
    {
        view.addSubview(questionsTable)
        
        questionsTable.snp.makeConstraints { make in
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
        navigationController?.pushViewController(FeedVC(), animated: true)
    }
    
    
}
