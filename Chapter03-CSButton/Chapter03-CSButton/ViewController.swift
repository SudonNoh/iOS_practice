//
//  ViewController.swift
//  Chapter03-CSButton
//
//  Created by Sudon Noh on 2023/01/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rectBtn = CSButton(type: .rect)
        rectBtn.frame = CGRect(x: 30, y: 200, width: 150, height: 30)
        self.view.addSubview(rectBtn)
        
        let circleBtn = CSButton(type: .circle)
        circleBtn.frame = CGRect(x: 200, y: 200, width: 150, height: 30)
        self.view.addSubview(circleBtn)
    }
}

