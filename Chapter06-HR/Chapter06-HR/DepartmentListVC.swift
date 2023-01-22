//
//  DepartmentListVC.swift
//  Chapter06-HR
//
//  Created by Sudon Noh on 2023/01/19.
//

import UIKit

class DepartmentListVC: UITableViewController {
    
    // 데이터베이스 소스용 멤버 변수
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    
    let departDAO = DepartmentDAO() // SQLite 처리를 담당할 DAO 객체
    
    // UI 초기화 함수
    func initUI() {
        // 1. 내비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "부서 목록\n" + " 총 \(self.departList.count) 개 "
        
        // 2. 내비게이션 바 UI 설정
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem // 편집 버튼 추가
        // editButtonItem은 UITableViewController 클래스에서 제공하는 바 버튼 아이템으로
        // 셀을 삭제할 수 있는 편집 모드 기능이 이미 구현되어 있는 특수 버튼이다.
        
        // 3. 셀을 스와이프했을 때 편집 모드가 되도록 설정
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departList = self.departDAO.find()
        self.initUI()
        /*
            // 프로그래밍 방식으로 테이블 뷰 하단에 뷰를 넣어 빈 셀이 표시되는 것을 방지하는 방법
            // 실전편 1051p
            let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
            self.tableView.tableFooterView = dummyView
        */
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath 매개변수가 가리키는 행에 대한 데이터를 읽어온다.
        let rowData = self.departList[indexPath.row]
        
        // 셀 객체를 생성하고 데이터를 배치한다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        
        var content = cell?.defaultContentConfiguration()
        content?.text = rowData.departTitle
        content?.textProperties.font = UIFont.systemFont(ofSize: 14)
        content?.secondaryText = rowData.departAddr
        content?.secondaryTextProperties.font = UIFont.systemFont(ofSize: 12)
        
        cell?.contentConfiguration = content
        
        
        /* deprecated
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        */
        return cell!
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규 부서 등록", message: "신규 부서를 등록해주세요.", preferredStyle: .alert)
        
        // 부서명 및 주소 입력용 텍스트 필드 추가
        alert.addTextField() { (tf) in tf.placeholder = "부서명" }
        alert.addTextField() { (tf) in tf.placeholder = "주소" }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
            let title = alert.textFields?[0].text
            let addr = alert.textFields?[1].text
            
            if self.departDAO.create(title: title, addr: addr) {
                // 신규 부서가 등록되면 DB에서 목록을 다시 읽어온 후, 테이블을 갱신해 준다.
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                // 내비게이션 타이틀에도 변경된 부서 정보를 반영한다.
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "부서 목록\n" + " 총 \(self.departList.count) 개 "
            }
        })
        
        self.present(alert, animated: false)
    }
    
    // 목록 편집 형식을 결정하는 함수(삭제/수정)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1. 삭제할 행의 departCd를 구한다.
        let departCd = self.departList[indexPath.row].departCd
        
        // 2. DB에서, 데이터 소스에서, 그리고 테이블 뷰에서 차례대로 삭제한다.
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let navTitle = self.navigationItem.titleView as! UILabel
            navTitle.text = "부서 목록\n" + " 총 \(self.departList.count) 개 "
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 화면 이동 시 함께 전달할 부서 코드
        let departCd = self.departList[indexPath.row].departCd
        
        // 이동할 대상 뷰 컨트롤러의 인스턴스
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        
        if let _infoVC = infoVC as? DepartmentInfoVC {
            // 부서 코드를 전달한 다음, 푸시 방식으로 화면 이동
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true)
        }
    }
}
