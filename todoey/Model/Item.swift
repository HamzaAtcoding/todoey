//
//  item.swift
//  todoey
//
//  Created by Hamza Iqbal on 13/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
