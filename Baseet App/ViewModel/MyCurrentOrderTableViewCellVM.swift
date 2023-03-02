//
//  MyCurrentOrderTableViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 25/09/22.
//

import Foundation

class MyCurrentOrderTableViewCellVM {
    var myOrder: Orders?
    var type: Int?
    
    init(myOrder: Orders, type: Int) {
        self.myOrder = myOrder
        self.type = type
    }
}

class MyPastOrderTableViewCellVM {
    var myOrder: Orders?
    var type: Int?
    
    init(myOrder: Orders, type: Int) {
        self.myOrder = myOrder
        self.type = type
    }
    
}
