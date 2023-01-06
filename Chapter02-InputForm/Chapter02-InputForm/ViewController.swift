//
//  ViewController.swift
//  Chapter02-InputForm
//
//  Created by Sudon Noh on 2023/01/06.
//

import UIKit

class ViewController: UIViewController {
    
    var paramEmail: UITextField! // 이메일 입력필드, 초기화 과정이 있어야 하기 때문에 상수가 아닌 변수로 선언
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    var txtUpdate: UILabel!
    var txtInterval: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 내비게이션 바 타이틀을 입력
        self.navigationItem.title = "설정"
        
        // 2. 이메일 레이블을 생성하고 영역과 기본 문구를 설정
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "이메일"
        // center 정렬
        // lblEmail.textAlignment = .center
        
        // 3. 레이블의 폰트를 설정
        lblEmail.font = UIFont.systemFont(ofSize: 14)
        // let font = UIFont.boldSystemFont(ofSize: 14)
        // let font = UIFont(name: "Chalkboard SE", size: 14)
        
        // 4. 레이블을 루트 뷰에 추가
        self.view.addSubview(lblEmail)
        
        // 자동갱신 레이블을 생성하고 루트 뷰에 추가
        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: 30, y: 150, width: 100, height: 30)
        lblUpdate.text = "자동갱신"
        lblUpdate.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(lblUpdate)
        
        // 갱신주기 레이블을 생성하고 루트 뷰에 추가
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: 30, y: 200, width: 100, height: 30)
        lblInterval.text = "갱신주기"
        lblInterval.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(lblInterval)
        
        // 이메일 입력을 위한 텍스트 필드를 추가
        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail.font = UIFont.systemFont(ofSize: 13)
        self.paramEmail.borderStyle = .roundedRect
        self.paramEmail.placeholder = "Email 입력"
        self.paramEmail.autocapitalizationType = .none // <- 대문자 자동 변환 기능 해제 구문
        
        self.view.addSubview(self.paramEmail)
        
        // 업데이트 설정을 위한 스위치 객체 추가
        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        
        // 스위치가 On 되어 있는 상태를 기본값으로 설정
        self.paramUpdate.setOn(true, animated: true)
        
        self.view.addSubview(self.paramUpdate)
        
        // 갱신주기를 위한 스테퍼 객체 추가
        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        self.paramInterval.minimumValue = 0
        self.paramInterval.maximumValue = 100
        self.paramInterval.stepValue = 1
        self.paramInterval.value = 0
        
        self.view.addSubview(self.paramInterval)
        
        // 스위치 객체의 값을 표현할 레이블을 추가
        self.txtUpdate = UILabel()
        
        self.txtUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate.font = UIFont.systemFont(ofSize: 12)
        self.txtUpdate.textColor = UIColor.blue
        self.txtUpdate.text = "갱신함"
        
        self.view.addSubview(self.txtUpdate)
        
        // 스텝퍼 객체의 값을 표현할 레이블을 추가
        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        self.txtInterval.font = UIFont.systemFont(ofSize: 12)
        self.txtInterval.textColor = UIColor.red
        self.txtInterval.text = "0분마다"
        
        self.view.addSubview(self.txtInterval)
        
        self.paramUpdate.addTarget(self, action: #selector (presentUpdateValue(_:)), for: .valueChanged)
        self.paramInterval.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        
        // 전송 버튼을 내비게이션 아이템에 추가하고, submit 메소드에 연결
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submitBtn
    }
    
    // 스위치와 상호반응할 액션 메소드
    @objc func presentUpdateValue(_ sender: UISwitch) {
        self.txtUpdate.text = (sender.isOn == true ? "갱신함" : "갱신하지 않음")
        self.txtUpdate.textColor = (sender.isOn == true ? UIColor.blue : UIColor.red)
    }
    
    // 스텝퍼와 상호반응할 액션 메소드
    @objc func presentIntervalValue(_ sender: UIStepper) {
        self.txtInterval.text = ("\( Int(sender.value))분마다")
    }
    
    // 전송 버튼과 상호반응할 액션 메소드
    @objc func submit(_ sender: Any) {
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail.text
        rvc.pUpdate = self.paramUpdate.isOn
        rvc.pInterval = self.paramInterval.value
        
        self.navigationController?.pushViewController(rvc, animated: true)
    }
}

