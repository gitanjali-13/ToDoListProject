//
//  Item.swift
//  TodoListDemo
//
//  Created by Admin on 22/12/22.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated :Date?
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
    
}
