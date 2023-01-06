//
//  ReadViewController.swift
//  Chapter02-InputForm
//
//  Created by Sudon Noh on 2023/01/06.
//

import UIKit

class ReadViewController: UIViewController {
    
    // 전달된 값을 저장할 변수를 정의
    var pEmail: String?
    var pUpdate: Bool?
    var pInterval: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상을 설정
        self.view.backgroundColor = .white
        
        let email = UILabel()
        let update = UILabel()
        let interval = UILabel()
        
        email.frame = CGRect(x: 50, y: 100, width: 300, height: 30)
        update.frame = CGRect(x: 50, y: 150, width: 300, height: 30)
        interval.frame = CGRect(x: 50, y: 200, width: 300, height: 30)
        
        email.text = "전달 받은 이메일: \(self.pEmail!)"
        update.text = "업데이트 여부: \(self.pUpdate == true ? "업데이트 함" : "업데이트 안 함")"
        interval.text = "업데이트 주기: \(self.pInterval!)분마다"
        
        self.view.addSubview(email)
        self.view.addSubview(update)
        self.view.addSubview(interval)
    }
}
