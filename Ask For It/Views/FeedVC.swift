//
//  FeedVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit
import SnapKit
import FirebaseAuth
class FeedVC: SpinnerBase
{
    
    var feedTable = UITableView()
    
    var vm = FeedViewModel()
    var isLoading = false
    let tableActiviyIndicator = UIActivityIndicatorView(style: .medium)

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        setupUI()
        setupTableViewFooter()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title  = "Browse"
        
    }
    
    func setupTableViewFooter() {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: feedTable.bounds.width, height: 44))
        tableActiviyIndicator.center = footerView.center
            footerView.addSubview(tableActiviyIndicator)
        tableActiviyIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        feedTable.tableFooterView = footerView
        }
    
    
    private func configureUI()
    {
        feedTable.register(FeedTableCell.self, forCellReuseIdentifier: FeedTableCell.identifier)
        feedTable.dataSource = self
        feedTable.delegate = self
        self.activityIndicatorBegin()
        isLoading = true

        vm.getQuestions {
            self.isLoading = false
            self.feedTable.reloadData()
            self.activityIndicatorEnd()


        }
        
    }
    
    func loadData()
    {
        guard !isLoading else { return }
        isLoading = true
        tableActiviyIndicator.startAnimating()

        vm.getQuestions {
            self.feedTable.reloadData()
            self.isLoading = false
            self.tableActiviyIndicator.stopAnimating()


        }
    }
    
    private func setupUI()
    {
        view.addSubview(feedTable)
        feedTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.sendSubviewToBack(feedTable)
        var addButton = UIBarButtonItem(title: "Ask", style: .plain, target: self, action: #selector(addTapped))
        addButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc func addTapped()
    {
        let vc = CreateQuestionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension FeedVC : UITableViewDelegate,UITableViewDataSource,CustomCellDelegate
{
    func profileTapped(_ user: String)
    {        
        let vc = VisitProfileVC()
        vc.vm.userID = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vm.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableCell.identifier, for: indexPath) as? FeedTableCell else {return UITableViewCell() }
        cell.set(  question: vm.questions[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let id = vm.questions[indexPath.row].option.first?.questionID else { return}
        
        let vc = AnswerQuestionVC()
        vc.vm.questionId = id
        navigationController?.pushViewController(vc, animated: true)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // Kullanıcı scrollView'in sonuna geldiğinde 100 piksel daha aşağı kaydırdığında çalışır.
        if offsetY > contentHeight - height + 200 {
            loadData()
            print("oldu")
        }
    }
    
    
    
}
