import UIKit
import Alamofire

struct UserInfoKey {
    // 저장에 사용할 키
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    static let tutorial = "TUTORIAL"
}

class UserInfoManager {
    // 연산 프로퍼티 loginId 정의
    var loginId: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    
    // 연산 프로퍼티 account 정의
    var account: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    // 연산 프로퍼티 name 정의
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    // 연산 프로퍼티 profile 정의
    var profile: UIImage? {
        get {
            let ud = UserDefaults.standard
            if let _profile = ud.data(forKey: UserInfoKey.profile) {
                return UIImage(data: _profile)
            } else {
                return UIImage(named: "account.jpg") // 이미지가 없다면 기본 이미지
            }
        }
        
        set(v) {
            if v != nil {
                print("UserInfoManager 실행")
                let ud = UserDefaults.standard
                ud.set(v!.pngData(), forKey: UserInfoKey.profile)
            }
        }
    }
    
    // 로그인 상태를 판별해주는 연산 프로퍼티 isLogin 정의
    var isLogin: Bool {
        // 로그인 아이디가 0이거나 계정이 비어 있으면
        if self.loginId == 0 || self.account == nil {
            return false
        } else {
            return true
        }
    }
    
    // 로그인 메소드 정의
    func login(account: String, passwd: String, success: (() -> Void)? = nil, fail: ((String) -> Void)? = nil) {
        // 1. URL과 전송할 값 준비
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/login"
        
        
        let param: Parameters = [
            "account": account,
            "passwd": passwd
        ]
        
        let call = AF.request(
            url,
            method: .post,
            parameters: param,
            encoding: JSONEncoding.default
        )
        
        /*
        call.responseJSON { res in
            // 3-1. JSON 형식으로 응답했는지 확인
            let result = try! res.result.get()
            guard let jsonObject = result as? NSDictionary else {
                fail?("잘못된 응답 형식입니다: \(result)")
                return
            }
            
            // 3-2. 응답 코드 확인. 0이면 성공
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                let user = jsonObject["user_info"] as! NSDictionary
                
                self.loginId = user["user_id"] as! Int
                self.account = user["account"] as? String
                self.name = user["name"] as? String
                
                if let path = user["profile_path"] as? String {
                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
                        self.profile = UIImage(data: imageData)
                    }
                }
                success?()
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "로그인에 실패했습니다."
                fail?(msg)
            }
        }
        */
    }
    
    func logout() -> Bool {
        let ud = UserDefaults.standard
        
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        
        return true
    }
}
