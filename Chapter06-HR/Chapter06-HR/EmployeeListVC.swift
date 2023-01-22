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
    
    // 새로고침 컨트롤에 들어갈 이미지 뷰
    var loadingImg: UIImageView!
    
    // 임계점에 도달했을 때 나타날 배경 뷰, 노란 원 형태
    var bgCircle: UIView!
    
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
        
        // 당겨서 새로고침 기능
        self.refreshControl = UIRefreshControl()
        // self.refreshControl?.attributedTitle = NSAttributedString(string: "댕겨서 새로고침")
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        /* 당겨서 새로고침 기능 커스텀 - 시작 */
        // 로딩 이미지 초기화 & 중앙 정렬
        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.refreshControl?.frame.width)! / 2
        
        self.refreshControl?.tintColor = .clear
        self.refreshControl?.addSubview(self.loadingImg)
        
        // 윗부분까지는 단순히 화면 당김에 따라 로딩 이미지가 회전하기만 할 뿐이라서,
        // 사용자는 언제 이 화면 당김을 중지해야 할지 판단하기 어려울 수 있기 때문에 로딩 이미지 주변에 원 모양의 배경 이미지가
        // 나타나 새로고침의 시작을 알려줄 수 있도록 한다.
        // 배경 뷰 초기화 및 노란 원 형태를 위한 속성 설정
        self.bgCircle = UIView()
        self.bgCircle.backgroundColor = UIColor.yellow
        self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
        
        // 배경 뷰를 refreshControl 객체에 추가하고, 로딩 이미지를 제일 위로 올림
        self.refreshControl?.addSubview(self.bgCircle)
        // 해당 서브 뷰를 가장 가장 앞쪽으로 순서를 바꿔주는 역할
        self.refreshControl?.bringSubviewToFront(self.loadingImg)
        /* 당겨서 새로고침 기능 커스텀 - 끝 */
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        // 새로고침 시 갱신되어야 할 내용들
        self.empList = self.empDAO.find()
        self.tableView.reloadData()
        
        // 당겨서 새로고침 기능 종료
        self.refreshControl?.endRefreshing()
        
        // 배경 뷰의 크기를 변화시키는 애니메이션을 구현한다.
        // 노란 원이 로딩 이미지를 중심으로 커지는 애니메이션
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        UIView.animate(withDuration: 0.5) {
            self.bgCircle.frame.size.width = 80
            self.bgCircle.frame.size.height = 80
            self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bgCircle.center.y = distance / 2
            self.bgCircle.layer.cornerRadius = (self.bgCircle?.frame.size.width)! / 2
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤이 발생할 때마다 처리할 내용을 여기에 작성
        // 당긴 거리
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        
        // center.y 좌표를 당긴 거리만큼 수정
        self.loadingImg.center.y = distance / 2
        
        // 당긴 거리를 회전 각도로 반환하여 로딩 이미지에 설정
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20))
        self.loadingImg.transform = ts
        
        // 배경 뷰의 중심 좌표 설정
        self.bgCircle.center.y = distance / 2
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 노란 원을 다시 초기화
        self.bgCircle.frame.size.width = 0
        self.bgCircle.frame.size.height = 0
        
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
