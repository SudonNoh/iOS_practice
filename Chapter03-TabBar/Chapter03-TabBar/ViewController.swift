//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by Sudon Noh on 2023/01/06.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) Title Label 생성
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        
        // 2) Title Label 속성 설정
        title.text = "첫번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)
        
        // 3) 콘텐츠 내용에 맞게 레이블 크기 변경
        title.sizeToFit()
        
        // 4) X축의 중앙에 오도록 설정
        // title 객체의 center 위치가 부모 뷰의 1/2 이다.
        title.center.x = self.view.frame.width / 2
        
        // 5) 수퍼 뷰에 추가
        self.view.addSubview(title)
    }
}

