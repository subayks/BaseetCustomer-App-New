//
//  SearchModel.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import Foundation

struct SearchModel: Codable {

  var totalSize : Int?        = nil
  var limit     : Int?        = nil
  var offset    : Int?        = nil
  var restaurants  : [RestaurantsModel]? = []
  var products: [FoodItems]? = []
  var errors : [ErrorMap]? = nil

  enum CodingKeys: String, CodingKey {

    case totalSize = "total_size"
    case limit     = "limit"
    case offset    = "offset"
    case restaurants  = "restaurants"
      case products = "products"
      case errors = "errors"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    totalSize = try values.decodeIfPresent(Int.self        , forKey: .totalSize )
    limit     = try values.decodeIfPresent(Int.self        , forKey: .limit     )
    offset    = try values.decodeIfPresent(Int.self        , forKey: .offset    )
    products = try values.decodeIfPresent([FoodItems].self , forKey: .products )
    restaurants  = try values.decodeIfPresent([RestaurantsModel].self , forKey: .restaurants )
    errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
  }

  init() {

  }

}
