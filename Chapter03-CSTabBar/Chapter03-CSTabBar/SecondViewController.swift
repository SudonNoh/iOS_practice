//
//  SecondViewController.swift
//  Chapter03-CSTabBar
//
//  Created by Sudon Noh on 2023/01/11.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let lb = UILabel()
        lb.frame = CGRect(x: 0, y: 300, width: 150, height: 50)
        lb.backgroundColor = .yellow
        lb.text = "두 번째 뷰"
        lb.textColor = .black
        lb.textAlignment = .center
        lb.center.x = self.view.frame.width / 2
        
        self.view.addSubview(lb)
    }

}
