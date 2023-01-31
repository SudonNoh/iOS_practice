//
//  ProfileVC.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/13.
//

import Foundation

/*
 UIImagePickerControllerDelegate, UINavigationControllerDelegate : 이미지 피커 컨트롤러는
 델리게이트 패턴을 기반으로 동작하기 때문에, 선택된 이미지 정보를 보내줄 델리게이트 대상이 필요합니다. 이 대상으로
 지정되려면 해당 객체가 위 두 개의 델리게이트 프로토콜을 구현하고 있어야 합니다. 이들 프로토콜에는 필수 메소드가
 없습니다.
*/
class ProfileVC:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    // 개인 정보 관리 매니저
    let uinfo = UserInfoManager()
    
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
        
        // 3. 셀 배경 이미지 설정
        let bg = UIImage(named: "profile-bg")
        let bgImg = UIImageView(image: bg)
        
        bgImg.frame.size = CGSize(width: bgImg.frame.size.width, height: bgImg.frame.size.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        
        self.view.addSubview(bgImg)
        
        // 2. 프로필 이미지 설정
        // let image = UIImage(named: "account.jpg")
        let image = self.uinfo.profile
        
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        
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
        
        /* 뷰 계층을 맞추려면 아래와 같이 입력 */
        // self.view.bringSubviewToFront(self.tv)
        // self.view.bringSubviewToFront(self.profileImage)
        
        // 내비게이션 바 숨김처리
        // self.navigationController?.navigationBar.isHidden = true
        // 최초 화면 로딩 시 로그인 상태에 따라 적절히 로그인/로그아웃 버튼 출력
        self.drawBtn()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            // cell.detailTextLabel?.text = "AXCE"
            cell.detailTextLabel?.text = self.uinfo.name ?? "Login please"
        case 1:
            cell.textLabel?.text = "계정"
            // cell.detailTextLabel?.text = "axce@naver.com"
            cell.detailTextLabel?.text = self.uinfo.account ?? "Login please"
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.uinfo.isLogin == false {
            // 로그인되어 있지 않다면 로그인 창을 띄워준다.
            self.doLogin(self.tv)
        }
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func doLogin(_ sender: Any) {
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        
        // 알림창에 들어갈 입력폼 추가
        loginAlert.addTextField() { (tf) in
            tf.placeholder = "Your Account"
        }
        loginAlert.addTextField() { (tf) in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        }
        
        // 알림창에 버튼 추가
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive) { (_) in
            
            let account = loginAlert.textFields?[0].text ?? ""
            let passwd = loginAlert.textFields?[1].text ?? ""
            
            self.uinfo.login(account: account, passwd: passwd, success: {
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
            }, fail: { msg in
                self.alert(msg)
            })
        })
        self.present(loginAlert, animated: false)
    }
    
    @objc func doLogout(_ sender: Any) {
        let msg = "로그아웃하시겠습니까?"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) {(_) in
            if self.uinfo.logout() {
                // TODO: (로그아웃 시 처리할 내용)
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
            }
        })
        self.present(alert, animated: false)
    }
    
    func drawBtn() {
        // 버튼을 감쌀 뷰를 정의
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        self.view.addSubview(v)
        
        // 버튼을 정의
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.height / 2
        
        // 로그인 상태일 때는 로그아웃 버튼을, 로그아웃 상태일 때는 로그인 버튼을 만들어 준다.
        if self.uinfo.isLogin == true {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout(_:)), for: .touchUpInside)
            print(self.uinfo.isLogin)
        } else {
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin(_:)), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    func imgPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    // 메소드가 호출되면 이미지 소스 타입을 선택하는 액션 시트 창이 나타나고, 여기서 선택한 소스 타입이 imgPicker(_:)
    // 메소드의 인자값으로 사용되도록 구현한다.
    @objc func profile(_ sender: UIButton) {
        // 로그인되어 있지 않을 경우에는 프로필 이미지 등록을 막고 대신 로그인 창을 띄워준다.
        guard self.uinfo.account != nil else {
            self.doLogin(self)
            return
        }
        
        let alert = UIAlertController(
            title: nil,
            message: "사진을 가져올 곳을 선택해 주세요.",
            preferredStyle: .actionSheet
        )
        
        // 카메라를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default) {
                (_) in self.imgPicker(.camera)
            })
        }
        
        // 저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "앨범", style: .default) {
                (_) in self.imgPicker(.savedPhotosAlbum)
            })
        }
        
        // 포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) {
                (_) in self.imgPicker(.photoLibrary)
            })
        }
        
        // 취소 버튼 추가
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // 액션 시트 창 실행
        self.present(alert, animated: true)
    }
    
    // 선택한 이미지를 전달받아 프로필 사진으로 등록할 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uinfo.profile = img
            self.profileImage.image = img
        }
        // 아래 구문이 없으면 이미지 피커 컨트롤러 창이 닫히지 않습니다.
        picker.dismiss(animated: true)
    }
    
    @IBAction func backProfileVC(_ segue: UIStoryboardSegue) {
        
    }
}
