//
//  ViewController.swift
//  Chapter05-CustomPlist
//
//  Created by Sudon Noh on 2023/01/17.
//

import UIKit

class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 메인 번들에 정의된 PList 내용을 저장할 딕셔너리
    var defaultPlist: NSDictionary!

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    /*
    var accountlist = [
        "AXCE@naver.com",
        "AXCE@gmail.com",
        "AXCE@kakao.com",
        "AXCE@github.com",
        "AXCE@facebook.com"
    ]
    */
    var accountlist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let defaultPlistPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPlist = NSDictionary(contentsOfFile: defaultPlistPath)
        }
        
        let picker = UIPickerView()
        
        // (1) 피커 뷰의 델리게이트 객체 지정
        picker.delegate = self
        // (2) account 텍스트 필드 입력 방식을 가상 키보드 대신 피커 뷰로 설정
        self.account.inputView = picker
        
        // 툴 바 객체 정의
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x:0, y:0, width: 0, height: 35)
        toolbar.barTintColor = .lightGray
        
        // 액세서리 뷰 영역에 툴 바를 표시
        self.account.inputAccessoryView = toolbar
        
        // 툴 바에 들어갈 닫기 버튼
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)
        
        // 툴 바 가변 폭 버튼 정의
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 툴 바 신규 계정 등록 버튼
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        // 버튼을 툴 바에 추가
        toolbar.setItems([new, flexSpace, done], animated: true)
        
        // 기본 저장소 객체 불러오기
        let plist = UserDefaults.standard
        
        // 불러온 값을 설정
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
        let accountlist = plist.array(forKey: "accountlist") as? [String] ?? [String]()
        self.accountlist = accountlist
        
        if let account = plist.string(forKey: "selectedAccount") {
            self.account.text = account
            
            let customPlist = "\(account).plist" // 읽어올 파일명
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        
        // 사용자 계정의 값이 비어 있다면 값을 설정하는 것을 막는다.
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다."
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
        
        // 내비게이션 바에 newAccount 메소드와 연결된 버튼을 추가한다.
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount(_:)))
        self.navigationItem.rightBarButtonItems = [addBtn]
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
        
        if let _account = self.account.text {
            
            let customPlist = "\(_account).plist" // 읽어올 파일명
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }
    
    @objc func newAccount(_ sender: Any) {
        self.view.endEditing(true) // 일단 입력용 뷰부터 닫는다.
        
        // 알림창 객체 생성
        let alert = UIAlertController(
            title: "새 계정을 입력하세요",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField() {
            $0.placeholder = "ex)abc@email.com"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) {(_) in
            if let account = alert.textFields?[0].text {
                // 계정 목록 배열에 추가한다.
                self.accountlist.append(account)
                // 계정 텍스트 필드에 표시한다.
                self.account.text = account
                
                // 컨트롤 값을 모두 초기화 한다.
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                // 계정 목록을 통째로 저장
                let plist = UserDefaults.standard
                plist.set(self.accountlist, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
                
                self.gender.isEnabled = true
                self.married.isEnabled = true
            }
        })
        // 알림창 오픈
        self.present(alert, animated: false, completion: nil)
    }
    
    // 생성할 컴포넌트의 개수를 정의
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // 지정된 컴포넌트가 가질 목록의 길이를 정의
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.accountlist.count
    }
    
    // 지정된 컴포넌트의 목록 각 행에 출력될 내용을 정의
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.accountlist[row]
    }
    
    // 지정된 컴포넌트의 목록 각 행을 사용자가 선택했을 때 실행할 액션을 정의
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountlist[row]
        self.account.text = account
        
        // 사용자가 계정을 생성하면 이 계정을 선택한 것으로 간주하고 저장
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        
        /*
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")
        plist.synchronize()
        */
        
        // 저장 로직
        let customPlist = "\(self.account.text!).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        
        data.setValue(value, forKey:"gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        
        /*
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
        plist.synchronize()
        */
        
        // 저장 로직
        let customPlist = "\(self.account.text!).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        
        data.setValue(value, forKey:"married")
        data.write(toFile: plist, atomically: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요.", preferredStyle: .alert)
            
            alert.addTextField() {
                $0.text = self.name.text
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) {(_) in
                let value = alert.textFields?[0].text
                
                /* 저장 로직은 이제 마스터 객체에 등록된 내용으로 저장하도록 한다.
                let plist = UserDefaults.standard
                plist.setValue(value, forKey: "name")
                plist.synchronize()
                */
                
                // 저장 로직 시작
                let customPlist = "\(self.account.text!).plist" // 읽어올 파일명
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
                
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)

                self.name.text = value
            })
            self.present(alert, animated: false, completion: nil)
        }
    }
}

