//
//  ProfileQuestionPageVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit

class ProfileQuestionPageVC: UIPageViewController {

    var pages : [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setPages()
        setViewControllers([pages[0]], direction: .forward, animated: true)
    }
    

    func changePage(index : Int)
    {
        setViewControllers([pages[index]], direction: .forward, animated: true)

    }
    
    func setPages()
    {
        let vc = CreatedQuestionsVC()
        vc.configure(with: UserInfo.shared.user)
        pages.append(vc)
        
        let vc2 = AnsweredQuestionsVC()
        vc2.configure(with: UserInfo.shared.user)
        pages.append(vc2)
    }
    

}


