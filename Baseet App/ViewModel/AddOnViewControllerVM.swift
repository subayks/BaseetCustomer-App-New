//
//  AddOnViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 07/08/22.
//

import Foundation

class AddOnViewControllerVM {
    var addOns: [AddOns]?
    var addonAdded = [AddOns]()
    var isFromCheckoutScreen: Bool = false
    
    init(addOns: [AddOns], isFromCheckoutScreen: Bool = false) {
        self.addOns = addOns
        self.isFromCheckoutScreen = isFromCheckoutScreen
    }
    
    func getAddOnTableViewCellVM(index: Int) ->AddOnTableViewCellVM {
        return AddOnTableViewCellVM(addOn: self.addOns?[index] ?? AddOns(), isFromCheckoutScreen: isFromCheckoutScreen)
    }
    
    func updateValues(itemCount: Int, index: Int) {

        var item = self.addOns?[index]
        item?.itemQuantity = itemCount
        
        for (indexValue, itemValue) in addonAdded.enumerated() {
            if itemValue.name == item?.name {
                if itemCount == 0 {
                    self.addonAdded.remove(at: indexValue)
                }
            }
        }
        
        self.addonAdded.append(item ?? AddOns())
        self.addonAdded = self.addonAdded.filter({$0.itemQuantity != 0})
    }
}
