//
//  HomeCollectionViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 03/08/22.
//

import Foundation
class HomeCollectionViewCellVM {
    var categoryListModel: CategoryListModel?
    
    init(categoryListModel: CategoryListModel?) {
        self.categoryListModel = categoryListModel
    }
}
