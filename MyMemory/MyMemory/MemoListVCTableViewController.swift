//
//  MemoListVCTableViewController.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/03.
//

import UIKit

class MemoListVCTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // 화면이 나타날 때마다 호출되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // 테이블 행의 개수를 결정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memolist.count
        return count
    }
    
    // 테이블 행을 구성하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼낸다.
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 2. 이미지 속성이 비어 있을 경우 "memoCell", 아니면 "memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        // 3. 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받는다.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        // 4. memoCell의 내용을 구성한다.
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        // 5. Date 타입의 날짜를 yyyy-mm-dd HH:mm:ss 포맷에 맞게 변경
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)
        
        // 6. cell 객체를 반환한다.
        return cell
    }
    
    // 테이블의 특정 행이 선택되었을 때 호출되는 메소드, 선택된 행의 정보는 indexPath에 담겨 전달된다.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. memolist 배열에서 선택된 행에 맞는 데이터를 꺼낸다.
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 2. 상세 화면의 인스턴스를 생성한다.
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        // 3. 값을 전달한 다음, 상세 화면으로 이동한다.
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
