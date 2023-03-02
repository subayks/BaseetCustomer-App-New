//
//  FavouriteModel.swift
//  Baseet App
//
//  Created by Subendran on 20/09/22.
//

import Foundation

struct FavouriteModel: Codable {

  var food       : [FoodItems]?   = []
  var restaurant: [RestaurantsModel]? = []
  var errors : [ErrorMap]? = nil

  enum CodingKeys: String, CodingKey {

    case food       = "food"
    case restaurant = "restaurants"
      case errors = "errors"

  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    food       = try values.decodeIfPresent([FoodItems].self   , forKey: .food       )
      restaurant = try values.decodeIfPresent([RestaurantsModel].self , forKey: .restaurant )
      errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
  }

  init() {

  }
}
