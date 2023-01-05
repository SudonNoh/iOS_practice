//
//  ViewController.swift
//  Chapter02-Button
//
//  Created by Sudon Noh on 2023/01/04.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 버튼 객체를 생성하고, 속성을 설정한다.
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.setTitle("테스트 버튼", for: .normal)
        
        btn.center = CGPoint(x: self.view.frame.size.width/2, y:100)
        
        self.view.addSubview(btn)
    }
}

