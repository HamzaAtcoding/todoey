//
//  Category.swift
//  todoey
//
//  Created by Hamza Iqbal on 13/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
