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
    
    var optionsStack : UIStackView = {
        var sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .fill
        
        return sv
    }()
    
    var textFieldArray = [UITextView()]
    
    var btn = CustomButton(title: "addOption", hasBackground: true, fontSize: .Big)

    var cellCount = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
        createOptions()
    }
    
    
    func setUI()
    {
        view.addSubViews(questionText,optionsStack,btn)
        
        questionText.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        optionsStack.snp.makeConstraints { make in
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
        cellCount += 1
        var option = textFieldArray[cellCount-1]
        DispatchQueue.main.async{
            option.layer.borderColor = UIColor.systemBackground.cgColor
            option.layer.borderWidth = 0
            UIView.animate(withDuration: 0.5) {
           
                option.layer.borderColor = UIColor.black.cgColor
                option.layer.borderWidth = 0.5
                option.isUserInteractionEnabled = true
            }
            
        }
        
    }
    
    func createOptions()
    {
        DispatchQueue.main.async{
            var option = UITextView()
            
            option.isScrollEnabled = false
            option.layer.borderColor = UIColor.black.cgColor
            option.layer.borderWidth = 0.5
            
            self.textFieldArray.append(option)
            self.optionsStack.addArrangedSubview(option)
            self.optionsStack.sizeToFit()
            self.optionsStack.layoutIfNeeded()
            
            for i in 0..<6
            {
                var option = UITextView()
                
                option.isScrollEnabled = false
                option.isUserInteractionEnabled = false
                
                self.textFieldArray.append(option)
                
                self.optionsStack.addArrangedSubview(option)
                self.optionsStack.sizeToFit()
                self.optionsStack.layoutIfNeeded()
            }
            
        }
        
    }
    
    
}

extension CreateQuestionVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableCell.identifier, for: indexPath) as? OptionsTableCell else {return UITableViewCell()}
        if indexPath.row != cellCount - 1
        {
            cell.contentView.isUserInteractionEnabled = true
            
        }
        else
        {
            cell.contentView.isUserInteractionEnabled = false
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.row == cellCount - 1
        {
            cellCount += 1
            
        }
    }
    
    
    
    
    
    
}
