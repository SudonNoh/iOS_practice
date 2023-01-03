//
//  MemoFormVCViewController.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/03.
//

import UIKit

class MemoFormVCViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    // 제목을 직접 입력받지 않고, 내용의 첫 줄을 추출하여 제목으로 사용
    // subject는 제목을 저장하는 역할을 담당
    var subject: String!

    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    @IBAction func save(_ sender: Any) {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
