//
//  Category.swift
//  TodoListDemo
//
//  Created by Admin on 22/12/22.
//

import Foundation
import RealmSwift

class Categories: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    let array = Array<Int>()
    
}
