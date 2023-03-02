//
//  GetCartModel.swift
//  Baseet App
//
//  Created by Subendran on 19/08/22.
//


import Foundation
struct GetCartModel: Codable {

  var data : [CartDataModel]? = []
    var errors : [ErrorMap]? = nil

  enum CodingKeys: String, CodingKey {

    case data = "data"
      case errors = "errors"

  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    data = try values.decodeIfPresent([CartDataModel].self , forKey: .data )
      errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors   )

  }

  init() {

  }

}

struct CartDataModel: Codable {
    
    var cartid                : String?        = nil
    var restauranName         : String?        = nil
    var deliverycharge        : String?        = nil
    var restauranApplogo      : String?        = nil
    var restauranAppcoverlogo : String?        = nil
    var restauranLatitude     : String?        = nil
    var restauranLongitude    : String?        = nil
    var cartfoodid            : String?        = nil
    var foodQty               : String?        = nil
    var cartuserid            : String?        = nil
    var addon                 : [CartAddOn]?      = []
    var id                    : String?        = nil
    var name                  : String?        = nil
    var appimage              : String?        = nil
    var description           : String?        = nil
    var image                 : String?        = nil
    var categoryId            : String?        = nil
    var categoryIds           : [CategoryIds]? = []
    var variations            : String?        = nil
    var addOns                : String?        = nil
    var attributes            : String?        = nil
    var choiceOptions         : String?        = nil
    var price                 : String?        = nil
    var tax                   : String?        = nil
    var taxType               : String?        = nil
    var discount              : String?        = nil
    var discountType          : String?        = nil
    var availableTimeStarts   : String?        = nil
    var availableTimeEnds     : String?        = nil
    var veg                   : String?        = nil
    var status                : String?        = nil
    var restaurantId          : String?        = nil
    var createdAt             : String?        = nil
    var updatedAt             : String?        = nil
    var orderCount            : String?        = nil
    var avgRating             : String?        = nil
    var ratingCount           : String?        = nil
    var rating                : String?        = nil
    var tprice                : Int?           = nil
    var timing                : String?        = nil

    enum CodingKeys: String, CodingKey {

      case cartid                = "cartid"
      case restauranName         = "restauran_name"
      case deliverycharge        = "delivery_charge"
      case restauranApplogo      = "restauran_applogo"
      case restauranAppcoverlogo = "restauran_appcoverlogo"
      case restauranLatitude     = "restauran_latitude"
      case restauranLongitude    = "restauran_longitude"
      case cartfoodid            = "cartfoodid"
      case foodQty               = "food_qty"
      case cartuserid            = "cartuserid"
      case addon                 = "addon"
      case id                    = "id"
      case name                  = "name"
      case appimage              = "appimage"
      case description           = "description"
      case image                 = "image"
      case categoryId            = "category_id"
      case categoryIds           = "category_ids"
      case variations            = "variations"
      case addOns                = "add_ons"
      case attributes            = "attributes"
      case choiceOptions         = "choice_options"
      case price                 = "price"
      case tax                   = "tax"
      case taxType               = "tax_type"
      case discount              = "discount"
      case discountType          = "discount_type"
      case availableTimeStarts   = "available_time_starts"
      case availableTimeEnds     = "available_time_ends"
      case veg                   = "veg"
      case status                = "status"
      case restaurantId          = "restaurant_id"
      case createdAt             = "created_at"
      case updatedAt             = "updated_at"
      case orderCount            = "order_count"
      case avgRating             = "avg_rating"
      case ratingCount           = "rating_count"
      case rating                = "rating"
      case tprice                = "tprice"
      case timing                = "timing"
    
    }

    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)

      cartid                = try values.decodeIfPresent(String.self        , forKey: .cartid                )
      restauranName         = try values.decodeIfPresent(String.self        , forKey: .restauranName         )
        deliverycharge      = try values.decodeIfPresent(String.self        , forKey: .deliverycharge)
      restauranApplogo      = try values.decodeIfPresent(String.self        , forKey: .restauranApplogo      )
      restauranAppcoverlogo = try values.decodeIfPresent(String.self        , forKey: .restauranAppcoverlogo )
      restauranLatitude     = try values.decodeIfPresent(String.self        , forKey: .restauranLatitude     )
      restauranLongitude    = try values.decodeIfPresent(String.self        , forKey: .restauranLongitude    )
      cartfoodid            = try values.decodeIfPresent(String.self        , forKey: .cartfoodid            )
      foodQty               = try values.decodeIfPresent(String.self        , forKey: .foodQty               )
      cartuserid            = try values.decodeIfPresent(String.self        , forKey: .cartuserid            )
      addon                 = try values.decodeIfPresent([CartAddOn].self      , forKey: .addon                 )
      id                    = try values.decodeIfPresent(String.self        , forKey: .id                    )
      name                  = try values.decodeIfPresent(String.self        , forKey: .name                  )
      appimage              = try values.decodeIfPresent(String.self        , forKey: .appimage              )
      description           = try values.decodeIfPresent(String.self        , forKey: .description           )
      image                 = try values.decodeIfPresent(String.self        , forKey: .image                 )
      categoryId            = try values.decodeIfPresent(String.self        , forKey: .categoryId            )
      categoryIds           = try values.decodeIfPresent([CategoryIds].self , forKey: .categoryIds           )
      variations            = try values.decodeIfPresent(String.self        , forKey: .variations            )
      addOns                = try values.decodeIfPresent(String.self        , forKey: .addOns                )
      attributes            = try values.decodeIfPresent(String.self        , forKey: .attributes            )
      choiceOptions         = try values.decodeIfPresent(String.self        , forKey: .choiceOptions         )
      price                 = try values.decodeIfPresent(String.self        , forKey: .price                 )
      tax                   = try values.decodeIfPresent(String.self        , forKey: .tax                   )
      taxType               = try values.decodeIfPresent(String.self        , forKey: .taxType               )
      discount              = try values.decodeIfPresent(String.self        , forKey: .discount              )
      discountType          = try values.decodeIfPresent(String.self        , forKey: .discountType          )
      availableTimeStarts   = try values.decodeIfPresent(String.self        , forKey: .availableTimeStarts   )
      availableTimeEnds     = try values.decodeIfPresent(String.self        , forKey: .availableTimeEnds     )
      veg                   = try values.decodeIfPresent(String.self        , forKey: .veg                   )
      status                = try values.decodeIfPresent(String.self        , forKey: .status                )
      restaurantId          = try values.decodeIfPresent(String.self        , forKey: .restaurantId          )
      createdAt             = try values.decodeIfPresent(String.self        , forKey: .createdAt             )
      updatedAt             = try values.decodeIfPresent(String.self        , forKey: .updatedAt             )
      orderCount            = try values.decodeIfPresent(String.self        , forKey: .orderCount            )
      avgRating             = try values.decodeIfPresent(String.self        , forKey: .avgRating             )
      ratingCount           = try values.decodeIfPresent(String.self        , forKey: .ratingCount           )
      rating                = try values.decodeIfPresent(String.self        , forKey: .rating                )
      tprice                = try values.decodeIfPresent(Int.self           , forKey: .tprice                )
      timing                = try values.decodeIfPresent(String.self        , forKey: .timing                )
   
    }

    init() {

    }

  }

struct CartAddOn: Codable {
    
    var addonname     : String? = nil
    var addonprice    : String? = nil
    var addonquantity : String? = nil
    var id            : String? = nil

    enum CodingKeys: String, CodingKey {

      case addonname     = "addonname"
      case addonprice    = "addonprice"
      case addonquantity = "addonquantity"
      case id            = "id"
    
    }

    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)

      addonname     = try values.decodeIfPresent(String.self , forKey: .addonname     )
      addonprice    = try values.decodeIfPresent(String.self , forKey: .addonprice    )
      addonquantity = try values.decodeIfPresent(String.self , forKey: .addonquantity )
      id            = try values.decodeIfPresent(String.self , forKey: .id            )
   
    }

    init() {

    }

  }
