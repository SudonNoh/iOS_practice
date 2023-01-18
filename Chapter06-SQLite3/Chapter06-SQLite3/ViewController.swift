//
//  ViewController.swift
//  Chapter06-SQLite3
//
//  Created by Sudon Noh on 2023/01/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SQLite 연결 정보를 담을 객체
        var db: OpaquePointer? = nil
        // 컴파일된 SQL을 담을 객체
        var stmt: OpaquePointer? = nil
        
        // 앱 내 문서 디렉토리 경로에서 SQLite DB 파일을 찾는다.
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
    }
}

