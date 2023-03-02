//
//  AddToCartModel.swift
//  Baseet App
//
//  Created by Subendran on 15/08/22.
//


import Foundation

struct AddToCartModel: Codable {
    var data: [CartData]? = nil
    var message   : String? = nil
    var errors : [ErrorMap]? = nil
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message   = "message"
      case errors = "errors"
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
        data =  try values.decodeIfPresent([CartData].self , forKey: .data   )
        message   = try values.decodeIfPresent(String.self , forKey: .message   )
          errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors   )
    }
    init() {

    }
}

struct CartData: Codable {

  var userId    : String?    = nil
  var foodId    : String? = nil
  var foodQty   : String? = nil
  var addonId   : String? = nil
  var addonQty  : String? = nil
  var updatedAt : String? = nil
  var createdAt : String? = nil
  var id        : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case userId    = "user_id"
    case foodId    = "food_id"
    case foodQty   = "food_qty"
    case addonId   = "addon_id"
    case addonQty  = "addon_qty"
    case updatedAt = "updated_at"
    case createdAt = "created_at"
    case id        = "id"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    userId    = try values.decodeIfPresent(String.self    , forKey: .userId    )
    foodId    = try values.decodeIfPresent(String.self , forKey: .foodId    )
    foodQty   = try values.decodeIfPresent(String.self , forKey: .foodQty   )
    addonId   = try values.decodeIfPresent(String.self , forKey: .addonId   )
    addonQty  = try values.decodeIfPresent(String.self , forKey: .addonQty  )
    updatedAt = try values.decodeIfPresent(String.self , forKey: .updatedAt )
    createdAt = try values.decodeIfPresent(String.self , forKey: .createdAt )
    id        = try values.decodeIfPresent(Int.self    , forKey: .id        )
  }

  init() {

  }

}

struct ErrorMap: Codable {

  var code    : String? = nil
  var message   : String? = nil
 

  enum CodingKeys: String, CodingKey {

    case code    = "code"
    case message    = "message"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

      code    = try values.decodeIfPresent(String.self , forKey: .code    )
      message   = try values.decodeIfPresent(String.self , forKey: .message   )
   

  }

  init() {

  }

}
