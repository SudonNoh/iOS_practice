//
//  MemoFormVCViewController.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/03.
//

import UIKit

class MemoFormVC:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextViewDelegate
{
    // 제목을 직접 입력받지 않고, 내용의 첫 줄을 추출하여 제목으로 사용
    // subject는 제목을 저장하는 역할을 담당
    var subject: String!
    lazy var dao = MemoDAO()
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    @IBAction func save(_ sender: Any) {
        // 경고창에 사용될 컨텐츠 뷰 컨트롤러 구성
        let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60")
        alertV.view = UIImageView(image: iconImage)
        alertV.preferredContentSize = iconImage?.size ?? CGSize.zero
        
        
        // 내용을 입력하지 않았을 경우, 경고 메시지
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // 콘텐츠 뷰 영역에 alertV를 등록
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: false)
            return
        }
        
        // MemoData 객체를 생성하고, 데이터를 담는다.
        let data = MemoData()
        
        data.title = self.subject // 제목
        data.contents = self.contents.text // 내용
        data.image = self.preview.image // 이미지
        data.regdate = Date() // 작성 시각
        
        // 앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData 객체를 추가한다.
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // appDelegate.memolist.append(data)
        // ⬆️ 로직의 흐름상 코어 데이터와 memolist 배열 양쪽에 모두 값을 추가할 필요는 없다.
        // 어차피 memolist 배열 역시 코어 데이터를 통해 값을 읽어와야 하기 때문이다.
        
        // 코어 데이터에 메모 데이터를 추가한다.
        self.dao.insert(data)
        
        // 작성폼 화면을 종료하고, 이전 화면으로 돌아간다.
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pick(_ sender: Any) {
        // 이미지 피커 인스턴스 생성
        let picker = UIImagePickerController()
        
        // 이미지 피커 컨트롤러 인스턴스의 델리게이트 속성을 현재의 뷰 컨트롤러 인스턴스로 설정
        picker.delegate = self
        // 이미지 피커 컨트롤러의 이미지 편집을 허용
        picker.allowsEditing = true
        
        // 이미지 피커 화면을 표시
        self.present(picker, animated: false)
    }
    
    // 사용자가 이미지를 선택하면 자동으로 이 메소드가 호출된다.
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        // 선택된 이미지를 미리보기에 출력한다.
        self.preview.image = info[.editedImage] as? UIImage
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
    }
    
    override func viewDidLoad() {
        // 사용자가 텍스트 뷰에 뭔가를 입력할 때 특정 델리게이트 메소드가 자동으로 호출되도록 한다.
        self.contents.delegate = self
        
        // 배경 이미지 설정
        let bgImage = UIImage(named:"memo-background.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        // 텍스트 뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        // 줄 간격
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: "", attributes: [.paragraphStyle: style])
    }
    
    // 사용자가 텍스트 뷰에 뭔가를 입력하면 자동으로 이 메소드가 호출
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트 뷰 구분
        // if textView == self.contents {
        //     print("확인")
        // }
        
        // tag 로 구분
        // if textView.tag == 0 {
        //     print("확인")
        // }
        
        
        // 내용의 최대 15자리까지 읽어 subject 변수에 저장
        let contents = textView.text as NSString
        let length = ( (contents.length > 15) ? 15 : contents.length )
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        // 내비게이션 타이틀에 표시한다.
        self.navigationItem.title = self.subject
    }
    
    // 내비게이션 바의 토글 처리
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts) {
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
}
