//
//  CSStepper.swift
//  Chapter03-CSStepper
//
//  Created by Sudon Noh on 2023/01/11.
//

import UIKit

@IBDesignable
class CSStepper: UIControl {
    
    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel()
    
    @IBInspectable
    public var value: Int = 0 {
        // 값이 변경될 때 마다 호출
        didSet {
            self.centerLabel.text = String(value)
            
            /*
             이 클래스를 사용하는 객체들에게 valueChanged 이벤트 신호를 보내준다.
             UIView에서 UIControl로 상속받는 클래스를 변경했을 경우에 사용 가능
             
             ".valueChanged" 는 UIControl 에 적용된 메소드로, value가 변경될 때 .valueChanged 이벤트를 발생시키라는 의미이다. ViewController 에서
             아래와 같이 입력되어 있다고 가정해보자.
             
             stepper.addTarget(self, action: #selector(logging(_:)), for: .valueChanged)
             
             @objc func logging(_ sender: CSStepper) {
                 NSLog("현재 스테퍼의 값은 \(sender.value)입니다.")
             }
             
             사용자가 스텝퍼를 눌러 값이 변경되는 경우, didSet 이 실행된다. 우선 centralLabel 의 텍스트 값이 변경되고, sendActions 에 의해 .valueChanged 이벤트를 발생시킨다.
             그러면 stepper 의 addTarget 에 설정되어 있는 액션(#selector(logging(_:)))이 발생해 logging 함수가 실행된다.
            */
            self.sendActions(for: .valueChanged)
        }
    }
    // 양 쪽 버튼이 변경할 수 있도록 만든 프로퍼티 옵저버
    @IBInspectable
    public var leftTitle: String = "⬇️" {
        didSet {
            self.leftBtn.setTitle(leftTitle, for: .normal)
        }
    }
    @IBInspectable
    public var rightTitle: String = "⬆️" {
        didSet {
            self.rightBtn.setTitle(rightTitle, for: .normal)
        }
    }
    
    // 스테퍼 중앙의 레이블 배경 색상을 커스터마이징 할 수 있도록 속성과 프로퍼티 옵저버 추가
    @IBInspectable
    public var bgColor: UIColor = UIColor.cyan {
        didSet {
            self.centerLabel.backgroundColor = bgColor
        }
    }
    
    // 증감값 단위
    @IBInspectable
    public var stepValue: Int = 1
    // 최대값과 최소값
    @IBInspectable public var maximumValue: Int = 100
    @IBInspectable public var minimumValue: Int = -100
    
    // 스토리보드에서 호출할 초기화 메소드
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // 프로그래밍 방식으로 호출할 초기화 메소드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        // 여기에 스테퍼의 기본 속성을 설정한다.
        // 동일 속성 변수 정의
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        
        // 좌측 다운 버튼 속성 설정
        self.leftBtn.tag = -1
        // self.leftBtn.setTitle("⬇️", for: .normal)
        // self.leftTitle로 초깃값을 설정하기 위해 변경
        self.leftBtn.setTitle(self.leftTitle, for: .normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor
        
        // 우측 업 버튼 속성 설정
        self.rightBtn.tag = 1
        // self.rightBtn.setTitle("⬆️", for: .normal)
        self.rightBtn.setTitle(self.rightTitle, for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor
        
        // 중앙 레이블 속성 설정
        self.centerLabel.text = String(value)
        self.centerLabel.font = UIFont.systemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        // self.centerLabel.backgroundColor = .cyan
        self.centerLabel.backgroundColor = self.bgColor
        self.centerLabel.layer.borderWidth = borderWidth
        self.centerLabel.layer.borderColor = borderColor
        
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)
        
        self.leftBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let btnWidth = self.frame.height
        let lblWidth = self.frame.width - (btnWidth * 2)
        
        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lblWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth+lblWidth, y: 0, width: btnWidth, height: btnWidth)
    }
    
    @objc public func valueChange(_ sender: UIButton) {
        let sum = self.value + (sender.tag * self.stepValue)

        if sum > self.maximumValue {
            return
        }

        if sum < self.minimumValue {
            return
        }

        self.value += (sender.tag * self.stepValue)
    }
}
