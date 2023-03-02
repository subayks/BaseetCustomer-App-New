//
//  AllRestaurentModel.swift
//  Baseet App
//
//  Created by Subendran on 04/08/22.
//


import Foundation

struct AllRestaurentModel: Codable {

  var totalSize   : Int?           = nil
  var limit       : String?        = nil
  var offset      : String?        = nil
  var restaurants : [Restaurants]? = []

  enum CodingKeys: String, CodingKey {

    case totalSize   = "total_size"
    case limit       = "limit"
    case offset      = "offset"
    case restaurants = "restaurants"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    totalSize   = try values.decodeIfPresent(Int.self           , forKey: .totalSize   )
    limit       = try values.decodeIfPresent(String.self        , forKey: .limit       )
    offset      = try values.decodeIfPresent(String.self        , forKey: .offset      )
    restaurants = try values.decodeIfPresent([Restaurants].self , forKey: .restaurants )
 
  }

  init() {

  }

}

struct Restaurants: Codable {

  var id                  : Int?    =    nil
  var name                : String? =    nil
  var phone               : String? =    nil
  var email               : String? =    nil
  var logo                : String? =    nil
  var latitude            : String? =    nil
  var longitude           : String? =    nil
  var address             : String? =    nil
  var footerText          : String? =    nil
  var minimumOrder        : Int?    =    nil
  var comission           : String? =    nil
  var scheduleOrder       : Bool?   =    nil
  var status              : Int?    =    nil
  var vendorId            : Int?    =    nil
  var createdAt           : String? =    nil
  var updatedAt           : String? =    nil
  var freeDelivery        : Bool?   =    nil
  var coverPhoto          : String? =    nil
  var applogo             : String? =    nil
  var appcoverlogo        : String? =    nil
  var delivery            : Bool?   =    nil
  var takeAway            : Bool?   =    nil
  var foodSection         : Bool?   =    nil
  var tax                 : Int?    =    nil
  var zoneId              : Int?    =    nil
  var reviewsSection      : Bool?   =    nil
  var active              : Bool?   =    nil
  var offDay              : String? =    nil
  var selfDeliverySystem  : Int?    =    nil
  var posSystem           : Bool?   =    nil
  var deliveryCharge      : Int?    =    nil
  var deliveryTime        : String? =    nil
  var veg                 : Int?    =    nil
  var nonVeg              : Int?    =    nil
  var orderCount          : String? =    nil
  var totalOrder          : String? =    nil
  var open                : Int?    =    nil
  var availableTimeStarts : String? =    nil
  var availableTimeEnds   : String? =    nil
  var avgRating           : Int?    =    nil
  var ratingCount           :       Int? =   nil
  var gstStatus           : Bool?   =    nil
  var gstCode             : String? =    nil
  var discount            : String? =    nil

  enum CodingKeys: String, CodingKey {

    case id                  = "id"
    case name                = "name"
    case phone               = "phone"
    case email               = "email"
    case logo                = "logo"
    case latitude            = "latitude"
    case longitude           = "longitude"
    case address             = "address"
    case footerText          = "footer_text"
    case minimumOrder        = "minimum_order"
    case comission           = "comission"
    case scheduleOrder       = "schedule_order"
    case status              = "status"
    case vendorId            = "vendor_id"
    case createdAt           = "created_at"
    case updatedAt           = "updated_at"
    case freeDelivery        = "free_delivery"
    case coverPhoto          = "cover_photo"
    case applogo             = "applogo"
    case appcoverlogo        = "appcoverlogo"
    case delivery            = "delivery"
    case takeAway            = "take_away"
    case foodSection         = "food_section"
    case tax                 = "tax"
    case zoneId              = "zone_id"
    case reviewsSection      = "reviews_section"
    case active              = "active"
    case offDay              = "off_day"
    case selfDeliverySystem  = "self_delivery_system"
    case posSystem           = "pos_system"
    case deliveryCharge      = "delivery_charge"
    case deliveryTime        = "delivery_time"
    case veg                 = "veg"
    case nonVeg              = "non_veg"
    case orderCount          = "order_count"
    case totalOrder          = "total_order"
    case open                = "open"
    case availableTimeStarts = "available_time_starts"
    case availableTimeEnds   = "available_time_ends"
    case avgRating           = "avg_rating"
    case ratingCount           =                       "rating_count "
    case gstStatus           = "gst_status"
    case gstCode             = "gst_code"
    case discount            = "discount"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id                  = try values.decodeIfPresent(Int.self    ,                               forKey: .id                  )
    name                = try values.decodeIfPresent(String.self ,                               forKey: .name                )
    phone               = try values.decodeIfPresent(String.self ,                               forKey: .phone               )
    email               = try values.decodeIfPresent(String.self ,                               forKey: .email               )
    logo                = try values.decodeIfPresent(String.self ,                               forKey: .logo                )
    latitude            = try values.decodeIfPresent(String.self ,                               forKey: .latitude            )
    longitude           = try values.decodeIfPresent(String.self ,                               forKey: .longitude           )
    address             = try values.decodeIfPresent(String.self ,                               forKey: .address             )
    footerText          = try values.decodeIfPresent(String.self ,                               forKey: .footerText          )
    minimumOrder        = try values.decodeIfPresent(Int.self    ,                               forKey: .minimumOrder        )
    comission           = try values.decodeIfPresent(String.self ,                               forKey: .comission           )
    scheduleOrder       = try values.decodeIfPresent(Bool.self   ,                               forKey: .scheduleOrder       )
    status              = try values.decodeIfPresent(Int.self    ,                               forKey: .status              )
    vendorId            = try values.decodeIfPresent(Int.self    ,                               forKey: .vendorId            )
    createdAt           = try values.decodeIfPresent(String.self ,                               forKey: .createdAt           )
    updatedAt           = try values.decodeIfPresent(String.self ,                               forKey: .updatedAt           )
    freeDelivery        = try values.decodeIfPresent(Bool.self   ,                               forKey: .freeDelivery        )
    coverPhoto          = try values.decodeIfPresent(String.self ,                               forKey: .coverPhoto          )
    applogo             = try values.decodeIfPresent(String.self ,                               forKey: .applogo             )
    appcoverlogo        = try values.decodeIfPresent(String.self ,                               forKey: .appcoverlogo        )
    delivery            = try values.decodeIfPresent(Bool.self   ,                               forKey: .delivery            )
    takeAway            = try values.decodeIfPresent(Bool.self   ,                               forKey: .takeAway            )
    foodSection         = try values.decodeIfPresent(Bool.self   ,                               forKey: .foodSection         )
    tax                 = try values.decodeIfPresent(Int.self    ,                               forKey: .tax                 )
    zoneId              = try values.decodeIfPresent(Int.self    ,                               forKey: .zoneId              )
    reviewsSection      = try values.decodeIfPresent(Bool.self   ,                               forKey: .reviewsSection      )
    active              = try values.decodeIfPresent(Bool.self   ,                               forKey: .active              )
    offDay              = try values.decodeIfPresent(String.self ,                               forKey: .offDay              )
    selfDeliverySystem  = try values.decodeIfPresent(Int.self    ,                               forKey: .selfDeliverySystem  )
    posSystem           = try values.decodeIfPresent(Bool.self   ,                               forKey: .posSystem           )
    deliveryCharge      = try values.decodeIfPresent(Int.self    ,                               forKey: .deliveryCharge      )
    deliveryTime        = try values.decodeIfPresent(String.self ,                               forKey: .deliveryTime        )
    veg                 = try values.decodeIfPresent(Int.self    ,                               forKey: .veg                 )
    nonVeg              = try values.decodeIfPresent(Int.self    ,                               forKey: .nonVeg              )
    orderCount          = try values.decodeIfPresent(String.self ,                               forKey: .orderCount          )
    totalOrder          = try values.decodeIfPresent(String.self ,                               forKey: .totalOrder          )
    open                = try values.decodeIfPresent(Int.self    ,                               forKey: .open                )
    availableTimeStarts = try values.decodeIfPresent(String.self ,                               forKey: .availableTimeStarts )
    availableTimeEnds   = try values.decodeIfPresent(String.self ,                               forKey: .availableTimeEnds   )
    avgRating           = try values.decodeIfPresent(Int.self    ,                               forKey: .avgRating           )
    ratingCount           =   try                                values.decodeIfPresent(Int.self ,       forKey:              .ratingCount  )
    gstStatus           = try values.decodeIfPresent(Bool.self   ,                               forKey: .gstStatus           )
    gstCode             = try values.decodeIfPresent(String.self ,                               forKey: .gstCode             )
    discount            = try values.decodeIfPresent(String.self ,                               forKey: .discount            )
 
  }

  init() {

  }

}
