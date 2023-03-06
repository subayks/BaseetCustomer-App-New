//
//  AddOnTableViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 07/08/22.
//

import Foundation

class AddOnTableViewCellVM {
    var addOn: AddOns?
    var isFromCheckoutScreen: Bool = false
    
    init(addOn: AddOns, isFromCheckoutScreen: Bool = false) {
        self.addOn = addOn
        self.isFromCheckoutScreen = isFromCheckoutScreen
    }
}
