//
//  SideBar.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/12.
//

import UIKit

class SideBarVC: UITableViewController {
    let nameLabel = UILabel() // 이름
    let emailLabel = UILabel() // 이메일
    let profileImage = UIImageView() // 프로필 이미지
    
    // 목록 데이터 배열
    let titles = ["새글 작성하기", "친구 새글", "달력으로 보기", "공지사항", "통계", "계정 관리"]
    
    // 아이콘 데이터 배열
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png"),
        UIImage(named: "icon06.png")
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용 큐에서 테이블 셀을 꺼내 온다. 없으면 새로 생성
        let id = "menucell" // 테이블 식별자
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
        // 타이틀과 이미지를 대입한다.
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        // 폰트 설정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    // SideBar에서 객체를 클릭하면 이동
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 새 글 작성하기 누르면 MemoForm 스토리보드로 이동
        if indexPath.row == 0 {
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoForm")
            // SideBar에서 직접적으로 frontViewController를 참조할 수 없어서 메인 뷰 컨트롤러를 참조해서 이동
            let target = self.revealViewController().frontViewController as! UINavigationController
            target.pushViewController(uv!, animated: true)
            self.revealViewController().revealToggle(self)
        } else if indexPath.row == 5 {
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "_Profile")
            uv?.modalPresentationStyle = .fullScreen
            // Trailing Closure 문법
            self.present(uv!, animated: true) {
                self.revealViewController().revealToggle(self)
            }
        }
    }
    
    override func viewDidLoad() {
        // 테이블 뷰의 헤더 역할을 할 뷰를 정의한다.
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        
        headerView.backgroundColor = .brown
        
        // 테이블 뷰의 헤더 뷰로 지정한다.
        self.tableView.tableHeaderView = headerView
        
        // 이름 레이블의 속성을 정의하고, 헤더에 뷰를 추가한다.
        self.nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        
        self.nameLabel.text = "AXCE"
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.nameLabel.backgroundColor = .clear
        
        headerView.addSubview(self.nameLabel)
        
        // 이메일 레이블의 속성을 정의하고, 헤더에 뷰를 추가한다.
        self.emailLabel.frame = CGRect(x: 70, y: 30, width: 100, height: 30)
        
        self.emailLabel.text = "AXCE@nxver.com"
        self.emailLabel.textColor = .white
        self.emailLabel.font = UIFont.systemFont(ofSize: 11)
        self.emailLabel.backgroundColor = .clear
        
        headerView.addSubview(self.emailLabel)
        
        // 기본 이미지를 구현한다.
        let defaultProfile = UIImage(named: "account.jpg")
        self.profileImage.image = defaultProfile
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        // 기본 이미지 둥글게 만들기
        self.profileImage.layer.cornerRadius = (self.profileImage.frame.width/2)
        
        self.profileImage.layer.borderWidth = 0 // 테두리 두께 0으로
        self.profileImage.layer.masksToBounds = true // 마스크 효과
        
        headerView.addSubview(self.profileImage)
    }
}
