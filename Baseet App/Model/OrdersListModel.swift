//
//  OrdersListModel.swift
//  Baseet App
//
//  Created by Subendran on 24/09/22.
//

import Foundation

struct OrdersListModel: Codable {
  var errors : [ErrorMap]? = nil
  var totalSize : Int?      = nil
  var limit     : String?   = nil
  var offset    : String?   = nil
  var orders    : [Orders]? = []

  enum CodingKeys: String, CodingKey {

    case totalSize = "total_size"
    case limit     = "limit"
    case offset    = "offset"
    case orders    = "orders"
      case errors = "errors"

  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    totalSize = try values.decodeIfPresent(Int.self      , forKey: .totalSize )
    limit     = try values.decodeIfPresent(String.self   , forKey: .limit     )
    offset    = try values.decodeIfPresent(String.self   , forKey: .offset    )
    orders    = try values.decodeIfPresent([Orders].self , forKey: .orders    )
      errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
  }

  init() {

  }

}

struct Orders: Codable {

  var id                       : Int?             = nil
  var userId                   : Int?             = nil
  var orderAmount              : Int?             = nil
  var couponDiscountAmount     : Int?             = nil
  var couponDiscountTitle      : String?          = nil
  var paymentStatus            : String?          = nil
  var orderStatus              : String?          = nil
  var totalTaxAmount           : Int?             = nil
  var paymentMethod            : String?          = nil
  var transactionReference     : String?          = nil
  var deliveryAddressId        : String?          = nil
  var deliveryManId            : Int?          = nil
  var couponCode               : String?          = nil
  var orderNote                : String?          = nil
  var orderType                : String?          = nil
  var checked                  : String?          = nil
  var restaurantId             : Int?             = nil
  var createdAt                : String?          = nil
  var updatedAt                : String?          = nil
  var deliveryCharge           : Int?             = nil
  var scheduleAt               : String?          = nil
  var callback                 : String?          = nil
  var otp                      : String?          = nil
  var pending                  : String?          = nil
  var accepted                 : String?          = nil
  var confirmed                : String?          = nil
  var processing               : String?          = nil
  var handover                 : String?          = nil
  var pickedUp                 : String?          = nil
  var delivered                : String?          = nil
  var canceled                 : String?          = nil
  var refundRequested          : String?          = nil
  var refunded                 : String?          = nil
  var deliveryAddress          : DeliveryAddress? = DeliveryAddress()
  var scheduled                : Int?             = nil
  var restaurantDiscountAmount : Int?             = nil
  var originalDeliveryCharge   : Int?             = nil
  var failed                   : String?          = nil
  var adjusment                : String?          = nil
  var edited                   : String?          = nil
  var zoneId                   : String?          = nil
  var detailsCount             : Int?             = nil
  var restaurant               : Restaurant?      = Restaurant()
  var deliveryMan              : DeliveryMan?     = DeliveryMan()

  enum CodingKeys: String, CodingKey {

    case id                       = "id"
    case userId                   = "user_id"
    case orderAmount              = "order_amount"
    case couponDiscountAmount     = "coupon_discount_amount"
    case couponDiscountTitle      = "coupon_discount_title"
    case paymentStatus            = "payment_status"
    case orderStatus              = "order_status"
    case totalTaxAmount           = "total_tax_amount"
    case paymentMethod            = "payment_method"
    case transactionReference     = "transaction_reference"
    case deliveryAddressId        = "delivery_address_id"
    case deliveryManId            = "delivery_man_id"
    case couponCode               = "coupon_code"
    case orderNote                = "order_note"
    case orderType                = "order_type"
    case checked                  = "checked"
    case restaurantId             = "restaurant_id"
    case createdAt                = "created_at"
    case updatedAt                = "updated_at"
    case deliveryCharge           = "delivery_charge"
    case scheduleAt               = "schedule_at"
    case callback                 = "callback"
    case otp                      = "otp"
    case pending                  = "pending"
    case accepted                 = "accepted"
    case confirmed                = "confirmed"
    case processing               = "processing"
    case handover                 = "handover"
    case pickedUp                 = "picked_up"
    case delivered                = "delivered"
    case canceled                 = "canceled"
    case refundRequested          = "refund_requested"
    case refunded                 = "refunded"
    case deliveryAddress          = "delivery_address"
    case scheduled                = "scheduled"
    case restaurantDiscountAmount = "restaurant_discount_amount"
    case originalDeliveryCharge   = "original_delivery_charge"
    case failed                   = "failed"
    case adjusment                = "adjusment"
    case edited                   = "edited"
    case zoneId                   = "zone_id"
    case detailsCount             = "details_count"
    case restaurant               = "restaurant"
    case deliveryMan              = "delivery_man"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id                       = try values.decodeIfPresent(Int.self             , forKey: .id                       )
    userId                   = try values.decodeIfPresent(Int.self             , forKey: .userId                   )
    orderAmount              = try values.decodeIfPresent(Int.self             , forKey: .orderAmount              )
    couponDiscountAmount     = try values.decodeIfPresent(Int.self             , forKey: .couponDiscountAmount     )
    couponDiscountTitle      = try values.decodeIfPresent(String.self          , forKey: .couponDiscountTitle      )
    paymentStatus            = try values.decodeIfPresent(String.self          , forKey: .paymentStatus            )
    orderStatus              = try values.decodeIfPresent(String.self          , forKey: .orderStatus              )
    totalTaxAmount           = try values.decodeIfPresent(Int.self             , forKey: .totalTaxAmount           )
    paymentMethod            = try values.decodeIfPresent(String.self          , forKey: .paymentMethod            )
    transactionReference     = try values.decodeIfPresent(String.self          , forKey: .transactionReference     )
    deliveryAddressId        = try values.decodeIfPresent(String.self          , forKey: .deliveryAddressId        )
    deliveryManId            = try values.decodeIfPresent(Int.self          , forKey: .deliveryManId            )
    couponCode               = try values.decodeIfPresent(String.self          , forKey: .couponCode               )
    orderNote                = try values.decodeIfPresent(String.self          , forKey: .orderNote                )
    orderType                = try values.decodeIfPresent(String.self          , forKey: .orderType                )
    checked                  = try values.decodeIfPresent(String.self          , forKey: .checked                  )
    restaurantId             = try values.decodeIfPresent(Int.self             , forKey: .restaurantId             )
    createdAt                = try values.decodeIfPresent(String.self          , forKey: .createdAt                )
    updatedAt                = try values.decodeIfPresent(String.self          , forKey: .updatedAt                )
    deliveryCharge           = try values.decodeIfPresent(Int.self             , forKey: .deliveryCharge           )
    scheduleAt               = try values.decodeIfPresent(String.self          , forKey: .scheduleAt               )
    callback                 = try values.decodeIfPresent(String.self          , forKey: .callback                 )
    otp                      = try values.decodeIfPresent(String.self          , forKey: .otp                      )
    pending                  = try values.decodeIfPresent(String.self          , forKey: .pending                  )
    accepted                 = try values.decodeIfPresent(String.self          , forKey: .accepted                 )
    confirmed                = try values.decodeIfPresent(String.self          , forKey: .confirmed                )
    processing               = try values.decodeIfPresent(String.self          , forKey: .processing               )
    handover                 = try values.decodeIfPresent(String.self          , forKey: .handover                 )
    pickedUp                 = try values.decodeIfPresent(String.self          , forKey: .pickedUp                 )
    delivered                = try values.decodeIfPresent(String.self          , forKey: .delivered                )
    canceled                 = try values.decodeIfPresent(String.self          , forKey: .canceled                 )
    refundRequested          = try values.decodeIfPresent(String.self          , forKey: .refundRequested          )
    refunded                 = try values.decodeIfPresent(String.self          , forKey: .refunded                 )
    deliveryAddress          = try values.decodeIfPresent(DeliveryAddress.self , forKey: .deliveryAddress          )
    scheduled                = try values.decodeIfPresent(Int.self             , forKey: .scheduled                )
    restaurantDiscountAmount = try values.decodeIfPresent(Int.self             , forKey: .restaurantDiscountAmount )
    originalDeliveryCharge   = try values.decodeIfPresent(Int.self             , forKey: .originalDeliveryCharge   )
    failed                   = try values.decodeIfPresent(String.self          , forKey: .failed                   )
    adjusment                = try values.decodeIfPresent(String.self          , forKey: .adjusment                )
    edited                   = try values.decodeIfPresent(String.self          , forKey: .edited                   )
    zoneId                   = try values.decodeIfPresent(String.self          , forKey: .zoneId                   )
    detailsCount             = try values.decodeIfPresent(Int.self             , forKey: .detailsCount             )
    restaurant               = try values.decodeIfPresent(Restaurant.self      , forKey: .restaurant               )
    deliveryMan              = try values.decodeIfPresent(DeliveryMan.self          , forKey: .deliveryMan              )

  }

  init() {

  }

}

struct DeliveryMan: Codable {

  var id                 : Int?    = nil
  var fName              : String? = nil
  var lName              : String? = nil
  var phone              : String? = nil
  var email              : String? = nil
  var identityNumber     : String? = nil
  var identityType       : String? = nil
  var identityImage      : String? = nil
  var image              : String? = nil
  var fcmToken           : String? = nil
  var zoneId             : Int?    = nil
  var createdAt          : String? = nil
  var updatedAt          : String? = nil
  var status             : Bool?   = nil
  var active             : Int?    = nil
  var earning            : Int?    = nil
  var currentOrders      : Int?    = nil
  var type               : String? = nil
  var restaurantId       : String? = nil
  var applicationStatus  : String? = nil
  var orderCount         : String? = nil
  var assignedOrderCount : String? = nil
  var avgRating          : Int?    = nil
  var ratingCount        : Int?    = nil
  var lat                : String? = nil
  var lng                : String? = nil
  var location           : String? = nil

  enum CodingKeys: String, CodingKey {

    case id                 = "id"
    case fName              = "f_name"
    case lName              = "l_name"
    case phone              = "phone"
    case email              = "email"
    case identityNumber     = "identity_number"
    case identityType       = "identity_type"
    case identityImage      = "identity_image"
    case image              = "image"
    case fcmToken           = "fcm_token"
    case zoneId             = "zone_id"
    case createdAt          = "created_at"
    case updatedAt          = "updated_at"
    case status             = "status"
    case active             = "active"
    case earning            = "earning"
    case currentOrders      = "current_orders"
    case type               = "type"
    case restaurantId       = "restaurant_id"
    case applicationStatus  = "application_status"
    case orderCount         = "order_count"
    case assignedOrderCount = "assigned_order_count"
    case avgRating          = "avg_rating"
    case ratingCount        = "rating_count"
    case lat                = "lat"
    case lng                = "lng"
    case location           = "location"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id                 = try values.decodeIfPresent(Int.self    , forKey: .id                 )
    fName              = try values.decodeIfPresent(String.self , forKey: .fName              )
    lName              = try values.decodeIfPresent(String.self , forKey: .lName              )
    phone              = try values.decodeIfPresent(String.self , forKey: .phone              )
    email              = try values.decodeIfPresent(String.self , forKey: .email              )
    identityNumber     = try values.decodeIfPresent(String.self , forKey: .identityNumber     )
    identityType       = try values.decodeIfPresent(String.self , forKey: .identityType       )
    identityImage      = try values.decodeIfPresent(String.self , forKey: .identityImage      )
    image              = try values.decodeIfPresent(String.self , forKey: .image              )
    fcmToken           = try values.decodeIfPresent(String.self , forKey: .fcmToken           )
    zoneId             = try values.decodeIfPresent(Int.self    , forKey: .zoneId             )
    createdAt          = try values.decodeIfPresent(String.self , forKey: .createdAt          )
    updatedAt          = try values.decodeIfPresent(String.self , forKey: .updatedAt          )
    status             = try values.decodeIfPresent(Bool.self   , forKey: .status             )
    active             = try values.decodeIfPresent(Int.self    , forKey: .active             )
    earning            = try values.decodeIfPresent(Int.self    , forKey: .earning            )
    currentOrders      = try values.decodeIfPresent(Int.self    , forKey: .currentOrders      )
    type               = try values.decodeIfPresent(String.self , forKey: .type               )
    restaurantId       = try values.decodeIfPresent(String.self , forKey: .restaurantId       )
    applicationStatus  = try values.decodeIfPresent(String.self , forKey: .applicationStatus  )
    orderCount         = try values.decodeIfPresent(String.self , forKey: .orderCount         )
    assignedOrderCount = try values.decodeIfPresent(String.self , forKey: .assignedOrderCount )
    avgRating          = try values.decodeIfPresent(Int.self    , forKey: .avgRating          )
    ratingCount        = try values.decodeIfPresent(Int.self    , forKey: .ratingCount        )
    lat                = try values.decodeIfPresent(String.self , forKey: .lat                )
    lng                = try values.decodeIfPresent(String.self , forKey: .lng                )
    location           = try values.decodeIfPresent(String.self , forKey: .location           )
 
  }

  init() {

  }

}

