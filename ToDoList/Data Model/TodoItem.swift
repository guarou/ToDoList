//
//  TodoItem.swift
//  ToDoList
//
//  Created by Study on 2018/10/30.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
