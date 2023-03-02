//
//  HomeCollectionViewDownCellVM.swift
//  Baseet App
//
//  Created by Subendran on 01/08/22.
//

import Foundation
struct shopDetails {
    
}
class HomeCollectionViewDownCellVM {
    var restaurantsModel: RestaurantsModel?
    var popularModel : PopularShopListModel?
    
    init(restaurantsModel: RestaurantsModel?) {
        self.restaurantsModel = restaurantsModel
    }
    init(popularModel: PopularShopListModel?){
        self.popularModel = popularModel
        
    }
    
}


    

