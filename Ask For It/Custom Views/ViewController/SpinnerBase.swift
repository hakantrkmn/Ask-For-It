//
//  SpinnerBase.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 8.05.2024.
//

import UIKit

class SpinnerBase: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func activityIndicatorBegin() {
        DispatchQueue.main.async{
            self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            self.activityIndicator.center = self.view.center
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.color = .label
            self.activityIndicator.style = .large
            self.view.addSubview(self.activityIndicator)

            self.activityIndicator.startAnimating()
            
        }
       

        
    }

    func activityIndicatorEnd() {
        DispatchQueue.main.async{
        self.activityIndicator.stopAnimating()
    }
    }

}
