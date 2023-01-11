//
//  ViewController.swift
//  Chapter03-NavigationBar
//
//  Created by Sudon Noh on 2023/01/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.initTitle()
        // self.initTitleNew()
        // self.initTitleImage()
        
        // 텍스트 필드를 이용해 타이틀을 구성하는 메소드
        self.initTitleInput()
    }
    
    func initTitle() {
        // 내비게이션 타이틀용 레이블 객체
        let nTitle = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
        // 속성설정
        nTitle.numberOfLines = 2 // 두 줄까지 표시되도록 설정
        nTitle.textAlignment = .center // 중앙정렬
        nTitle.textColor = .white // 텍스트 색상 설정
        nTitle.font = UIFont.systemFont(ofSize: 15) // 폰트 크기
        nTitle.text = "58개 숙소 \n 1박(1월 10일 ~ 1월 11일)"
        
        // 내비게이션 타이틀에 입력
        self.navigationItem.titleView = nTitle
        
        // 배경 색 설정 안됨 확인이 필요함
        // let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        // self.navigationController?.navigationBar.barTintColor = color
        
        // 아래와 같은 방법으로 배경 설정 가능
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // appearance.backgroundColor = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        appearance.backgroundColor = UIColor.white
        // shadow 설정
        appearance.shadowColor = UIColor.red
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
    }

    func initTitleNew() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        
        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.textAlignment = .center
        topTitle.font = UIFont.systemFont(ofSize: 15)
        topTitle.textColor = .systemGray
        topTitle.text = "58개 숙소"
        
        let subTitle = UILabel(frame: CGRect(x: 0, y: 18, width: 200, height: 18))
        
        subTitle.numberOfLines = 1
        subTitle.textAlignment = .center
        subTitle.font = UIFont.systemFont(ofSize: 12)
        subTitle.textColor = .systemGray4
        subTitle.text = "1박(1월 10일 ~ 1월 11일)"
        
        containerView.addSubview(topTitle)
        containerView.addSubview(subTitle)
        
        self.navigationItem.titleView = containerView
    }
    
    func initTitleImage() {
        
        // let appearance = UINavigationBarAppearance()
        // let image = UIImage(named: "swift_logo")
        // appearance.backgroundImage = image
        // self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // self.navigationController?.navigationBar.standardAppearance = appearance
        
        let image = UIImage(named: "swift_logo")
        let imageV = UIImageView(image: image)
        self.navigationItem.titleView = imageV
    }
    
    func initTitleInput() {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
        tf.backgroundColor = .white
        tf.font = UIFont.systemFont(ofSize: 13) // 입력할 글씨 크기를 13픽셀로
        tf.autocapitalizationType = .none // 자동 대문자 변환 속성은 사용하지 않도록
        tf.autocorrectionType = .no // 자동 입력 기능 해제
        tf.spellCheckingType = .no // 스펠링 체크 기능 해제
        tf.keyboardType = .URL
        tf.keyboardAppearance = .dark
        tf.layer.borderWidth = 0.3
        tf.layer.borderColor = UIColor(red:0.60, green: 0.60, blue: 0.60, alpha: 1.0).cgColor
        
        self.navigationItem.titleView = tf
        
        /* Navibar 에 View 영역 추가하는 방법
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 150, height: 37)
        v.backgroundColor = .brown
        
        let leftItem = UIBarButtonItem(customView: v)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rv = UIView()
        rv.frame = CGRect(x: 0, y: 0, width: 100, height: 37)
        rv.backgroundColor = .red
        
        let rightItem = UIBarButtonItem(customView: rv)
        self.navigationItem.rightBarButtonItem = rightItem
        */
        
        let back = UIImage(named: "arrow-back")
        let leftItem = UIBarButtonItem(image: back, style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rv = UIView()
        rv.frame = CGRect(x: 0, y: 0, width: 70, height: 37)
        
        let rItem = UIBarButtonItem(customView: rv)
        self.navigationItem.rightBarButtonItem = rItem
        
        let cnt = UILabel()
        cnt.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        cnt.font = UIFont.boldSystemFont(ofSize: 10)
        cnt.textColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
        cnt.text = "12"
        cnt.textAlignment = .center
        
        cnt.layer.cornerRadius = 3
        cnt.layer.borderWidth = 2
        cnt.layer.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0).cgColor
        
        rv.addSubview(cnt)
        
        let more = UIButton(type: .system)
        more.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        more.setImage(UIImage(named: "more"), for: .normal)
        
        rv.addSubview(more)
    }
}

