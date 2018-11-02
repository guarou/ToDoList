//
//  Category.swift
//  ToDoList
//
//  Created by Study on 2018/10/30.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<TodoItem>()
}
