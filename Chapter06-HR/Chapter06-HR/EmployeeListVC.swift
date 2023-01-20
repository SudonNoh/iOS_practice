//
//  EmployeeListVC.swift
//  Chapter06-HR
//
//  Created by Sudon Noh on 2023/01/19.
//

import UIKit

class EmployeeListVC: UITableViewController {
    
    // 데이터 소스를 저장할 멤버 변수
    var empList : [EmployeeVO]!
    // SQLite 처리를 담당할 DAO 클래스
    var empDAO = EmployeeDAO()
    
    // UI초기화 함수
    func initUI() {
        // 내비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "사원 목록\n" + " 총 \(self.empList.count) 명 "
        
        self.navigationItem.titleView = navTitle
    }
    
    override func viewDidLoad() {
        self.empList = self.empDAO.find()
        self.initUI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        
        // 사원명 + 재직 상태 출력
        var content = cell?.defaultContentConfiguration()
        
        content?.text = rowData.empName + "(\(rowData.stateCd.desc()))"
        content?.textProperties.font = UIFont.systemFont(ofSize: 14)
        content?.secondaryText = rowData.departTitle
        content?.secondaryTextProperties.font = UIFont.systemFont(ofSize: 12)
        
        cell?.contentConfiguration = content
        
        return cell!
    }
    
    @IBAction func add(_ sender: Any) {
        
        let alert = UIAlertController(title: "사원 등록", message: "등록할 사원 정보를 입력해 주세요.", preferredStyle: .alert)
        
        alert.addTextField() { (tf) in tf.placeholder = "사원명" }
        
        // contentViewController 영역에 부서 선택 피커 뷰 삽입
        let pickervc = DepartPickerVC()
        alert.setValue(pickervc, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
            
            // 1. 알림창의 입력 필드에서 값을 읽어온다.
            var param = EmployeeVO()
            param.departCd = pickervc.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!
            
            // 2. 가입일은 오늘로 한다.
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            
            // 3. 재직 상태는 '재직중'으로 한다.
            param.stateCd = EmpStateType.ING
            
            // 4. DB 처리
            if self.empDAO.create(param: param) {
                // 4-1. 결과가 성공이면 데이터를 다시 읽어들여 테이블 뷰를 갱신한다.
                self.empList = self.empDAO.find()
                self.tableView.reloadData()
                
                // 4-2. 내비게이션 타이틀을 갱신한다.
                if let navTitle = self.navigationItem.titleView as? UILabel {
                    navTitle.text = "사원 목록\n" + " 총 \(self.empList.count) 명 "
                }
            }
        })
        
        self.present(alert, animated: false)
        
    }
    
    // MARK: self.editButtonItem 없이 편집 버튼 구현
    @IBAction func editing(_ sender: Any) {
        
        if self.isEditing == false {
            // 현재 편집 모드가 아닐 때
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            // 현재 편집 모드일 때
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    // 목록 편집 형식을 결정하는 메소드(삽입 / 삭제)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    // DB, 데이터 소스, 테이블 뷰에서 차례로 관련 데이터를 삭제하는 구문
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1. 삭제할 행의 empCd를 구한다.
        let empCd = self.empList[indexPath.row].empCd
        
        // 2. DB에서, 데이터 소스에서, 그리고 테이블 뷰에서 차례대로 삭제한다.
        if empDAO.remove(empCd: empCd) {
            self.empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let navTitle = self.navigationItem.titleView as! UILabel
            navTitle.text = "사원 목록\n" + " 총 \(self.empList.count) 명 "
        }
    }
}
