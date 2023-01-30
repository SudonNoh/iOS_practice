import UIKit
import CoreData

class LogVC: UITableViewController {
    var board: BoardMO! // 게시글 정보를 전달받을 변수
    
    lazy var list: [LogMO]! = {
        return self.board.logs?.array as! [LogMO]
    }()
    
    override func viewDidLoad() {
        self.navigationItem.title = self.board.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "logcell")!
        
        var context = cell.defaultContentConfiguration()
        context.text = "\(row.regdate!)에 \(row.type.toLogType()) 되었습니다."
        context.textProperties.font = UIFont.systemFont(ofSize: 12)
        
        cell.contentConfiguration = context
        
        return cell
    }
}

public enum LogType: Int16 {
    case create = 0
    case edit = 1
    case delete = 2
}

extension Int16 {
    func toLogType() -> String {
        switch self {
        case 0: return "create"
        case 1: return "edit"
        case 2: return "delete"
        default: return ""
        }
    }
}
