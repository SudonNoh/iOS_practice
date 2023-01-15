//
//  ProfileVC.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/13.
//

import Foundation

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let profileImage = UIImageView() // 프로필 사진 이미지
    let tv = UITableView() // 프로필 목록
    
    override func viewDidLoad() {
        /* 나 혼자 해보는 꾸미기 */
        // 아래만 입력하면 내비게이션에 있는 글자 뒤에 그림자가 생김
        // self.navigationController?.navigationBar.layer.shadowColor = UIColor.brown.cgColor
        // self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0) // 그림자의 두깨
        // self.navigationController?.navigationBar.layer.shadowRadius = 4.0 // 글씨 바로 뒤에 생기는 그림자를 둥글둥글하게 만들어 줌
        // self.navigationController?.navigationBar.layer.shadowOpacity = 1.0 // 투명도 높을수록 진함
        
        // 아래와 같은 방식만 입력하면 내비게이션바 자체에 그림자가 생김
        let standard = UINavigationBarAppearance()
        standard.configureWithOpaqueBackground()
        standard.backgroundColor = .white
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.red.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 5.0, height: 2.0) // width: 그림자가 얼마나 우측으로 물러나있나? height: 그림자 길이
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0 // shadow 선명도 , 낮을수록 선명함
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0 // shadow 투명도 , 높을수록 투명함
        self.navigationController?.navigationBar.scrollEdgeAppearance = standard
        self.navigationController?.navigationBar.standardAppearance = standard
        /* 나 혼자 해보는 꾸미기 */
        
        // 1. navigation 설정
        self.navigationItem.title = "Profile"
        
        // 뒤로 가기 버튼 처리
        let backBtn = UIBarButtonItem(
            title: "닫기",
            style: .plain,
            target: self,
            action: #selector(close(_:))
        )
        self.navigationItem.leftBarButtonItem = backBtn
        
        // 2. 이미지 설정
        let image = UIImage(named: "account.jpg")
        
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 160)
        
        // 이미지 둥글게 만들기
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        
        self.view.addSubview(self.profileImage)
        
        // 3. 테이블 뷰
        self.tv.frame = CGRect(
            x: 0,
            // origin.y : profileImage의 y값
            y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20,
            width: self.view.frame.width,
            height: 100
        )
        
        self.tv.dataSource = self
        self.tv.delegate = self
        
        self.view.addSubview(self.tv)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
