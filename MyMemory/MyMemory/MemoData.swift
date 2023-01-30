//
//  MemoData.swift
//  MyMemory
//
//  Created by Sudon Noh on 2023/01/03.
//

import UIKit
import CoreData

class MemoData {
    var memoIdx: Int?
    var title: String?
    var contents: String?
    var image: UIImage?
    var regdate: Date?
    // 원본 MemoMO 객체를 참조하기 위한 속성
    var objectID: NSManagedObjectID?
}
