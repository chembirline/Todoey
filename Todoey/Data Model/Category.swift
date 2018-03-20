//
//  Category.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 20.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
