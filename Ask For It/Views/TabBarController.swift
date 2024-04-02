//
//  TabBarController.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 1.04.2024.
//

import UIKit

class TabBarController: UITabBarController
{

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs()
    {
        self.setViewControllers([createNav(with: "Feed", image: UIImage(systemName: "house"), vc: FeedVC()),createNav(with: "Profile", image: UIImage(systemName: "person.crop.circle"), vc: ProfileVC())], animated: true)
    }
    
    private func createNav(with title : String , image : UIImage?, vc : UIViewController) -> UINavigationController
    {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        nav.viewControllers.first?.navigationItem.title = title
        
        return nav
    }


}
