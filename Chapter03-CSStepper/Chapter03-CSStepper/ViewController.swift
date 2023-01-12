//
//  ViewController.swift
//  Chapter03-CSStepper
//
//  Created by Sudon Noh on 2023/01/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        stepper.bgColor = UIColor.yellow
        stepper.leftTitle = "-"
        stepper.rightTitle = "+"
        stepper.value = 25
        
        // ValueChange 이벤트가 발생하면 loggin(_:) 메소드가 호출되도록
        stepper.addTarget(self, action: #selector(logging(_:)), for: .valueChanged)
        
        self.view.addSubview(stepper)
    }
    
    @objc func logging(_ sender: CSStepper) {
        NSLog("현재 스테퍼의 값은 \(sender.value)입니다.")
    }
}

