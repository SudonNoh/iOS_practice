enum EmpStateType: Int {
case ING = 0, STOP, OUT // 순서대로 재직중(0), 휴직(1), 퇴사(2)
    
    // 재직 상태를 문자열로 반환해 주는 메소드
    func desc() -> String {
        switch self {
        case .ING:
            return "재직중"
        case .STOP:
            return "휴직중"
        case .OUT:
            return "퇴사"
        }
    }
}

struct EmployeeVO {
    var empCd = 0 // 사원코드
    var empName = "" // 사원명
    var joinDate = "" // 입사일
    var stateCd = EmpStateType.ING // 재직 상태(기본값 : 재직중)
    var departCd = 0 // 소속 부서 코드
    var departTitle = "" // 소속 부서명
}

class EmployeeDAO {
    // FMDatabase 객체 생성 및 초기화
    lazy var fmdb: FMDatabase! = {
        // 1. 파일 매니저 객체를 생성한다.
        let fileMgr = FileManager.default
        
        // 2. 샌드박스 내 문서 디렉터리 경로에서 데이터베이스 파일을 읽어온다.
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appending(component: "hr.sqlite").path()
        // *deprecated
        // let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        // 3. 샌드박스 경로에 hr.sqlite 파일이 없다면 메인 번들에 만들어 둔 파일을 가져와 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        // 4. 준비된 데이터베이스 파일을 바탕으로 FMDatabase 객체를 생성한다.
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }
    
    func find() -> [EmployeeVO] {
        // 반환할 데이터를 담을 [EmployeeVO] 타입의 객체 정의
        var employeeList = [EmployeeVO]()
        
        do {
            let sql =
                """
                SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
                FROM employee
                JOIN department On department.depart_cd = employee.depart_cd
                ORDER BY employee.depart_cd ASC
                """
            
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                var record = EmployeeVO()
                
                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!
                
                let cd = Int(rs.int(forColumn: "state_cd"))
                record.stateCd = EmpStateType(rawValue: cd)!
                
                employeeList.append(record)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return employeeList
    }
    
    func get(empCd: Int) -> EmployeeVO? {
        let sql =
                """
                SELECT emp_cd,emp_name, join_date, state_cd, department.depart_title
                FROM employee
                JOIN department On department.depart_cd = employee.depart_cd
                WHERE emp_cd = ?
                """
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])
        
        // 결과 집합 처리
        if let _rs = rs {
            _rs.next()
            
            var record = EmployeeVO()
            record.empCd = Int(_rs.int(forColumn: "emp_cd"))
            record.empName = _rs.string(forColumn: "emp_name")!
            record.joinDate = _rs.string(forColumn: "join_date")!
            record.departTitle = _rs.string(forColumn: "depart_title")!
            
            let cd = Int(_rs.int(forColumn: "state_cd"))
            record.stateCd = EmpStateType(rawValue: cd)!
            
            return record
        } else {
            return nil
        }
    }
    
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql =
                """
                INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
                VALUES ( ? , ? , ? , ? )
                """
            
            // Prepared Statement를 위한 인자값
            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)
            
            print(params)
            
            try self.fmdb.executeUpdate(sql, values: params)
            
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }
    
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM employee WHERE emp_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [empCd])
            return true
        } catch let error as NSError {
            print("Delete Error : \(error.localizedDescription)")
            return false
        }
    }
}
