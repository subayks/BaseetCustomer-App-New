//
//  OrderTrackModel.swift
//  Baseet App
//
//  Created by Subendran on 24/09/22.
//

import Foundation

struct OrderTrackModel: Codable {
    
    var errors : [ErrorMap]? = nil
    
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
    var deliveryManId            : Int?             = nil
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
    var details                  : [Details]?       = []
    var totalTime                : String?         = nil
    
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
        case details                  = "details"
        case totalTime                = "total_time"
        case errors = "errors"
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
        deliveryManId            = try values.decodeIfPresent(Int.self             , forKey: .deliveryManId            )
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
        deliveryMan              = try values.decodeIfPresent(DeliveryMan.self     , forKey: .deliveryMan              )
        details                  = try values.decodeIfPresent([Details].self       , forKey: .details                  )
        totalTime                = try values.decodeIfPresent(String.self, forKey: .totalTime)
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
        
    }
    
    init() {
        
    }
    
}

struct DeliveryAddress: Codable {
    
    var contactPersonName   : String? = nil
    var contactPersonNumber : String? = nil
    var addressType         : String? = nil
    var address             : String? = nil
    var longitude           : String? = nil
    var latitude            : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case contactPersonName   = "contact_person_name"
        case contactPersonNumber = "contact_person_number"
        case addressType         = "address_type"
        case address             = "address"
        case longitude           = "longitude"
        case latitude            = "latitude"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        contactPersonName   = try values.decodeIfPresent(String.self , forKey: .contactPersonName   )
        contactPersonNumber = try values.decodeIfPresent(String.self , forKey: .contactPersonNumber )
        addressType         = try values.decodeIfPresent(String.self , forKey: .addressType         )
        address             = try values.decodeIfPresent(String.self , forKey: .address             )
        longitude           = try values.decodeIfPresent(String.self , forKey: .longitude           )
        latitude            = try values.decodeIfPresent(String.self , forKey: .latitude            )
        
    }
    
    init() {
        
    }
    
}

struct Details: Codable {
    
    var id              : Int?         = nil
    var foodId          : Int?         = nil
    var orderId         : Int?         = nil
    var price           : Int?         = nil
    var foodDetails     : FoodDetails? = FoodDetails()
    var variation       : [String]?    = []
    var addOns          : [AddOns]?    = []
    var discountOnFood  : Int?         = nil
    var discountType    : String?      = nil
    var quantity        : Int?         = nil
    var taxAmount       : Int?         = nil
    var variant         : String?      = nil
    var createdAt       : String?      = nil
    var updatedAt       : String?      = nil
    var itemCampaignId  : String?      = nil
    var totalAddOnPrice : Int?         = nil
    
    enum CodingKeys: String, CodingKey {
        
        case id              = "id"
        case foodId          = "food_id"
        case orderId         = "order_id"
        case price           = "price"
        case foodDetails     = "food_details"
        case variation       = "variation"
        case addOns          = "add_ons"
        case discountOnFood  = "discount_on_food"
        case discountType    = "discount_type"
        case quantity        = "quantity"
        case taxAmount       = "tax_amount"
        case variant         = "variant"
        case createdAt       = "created_at"
        case updatedAt       = "updated_at"
        case itemCampaignId  = "item_campaign_id"
        case totalAddOnPrice = "total_add_on_price"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id              = try values.decodeIfPresent(Int.self         , forKey: .id              )
        foodId          = try values.decodeIfPresent(Int.self         , forKey: .foodId          )
        orderId         = try values.decodeIfPresent(Int.self         , forKey: .orderId         )
        price           = try values.decodeIfPresent(Int.self         , forKey: .price           )
        foodDetails     = try values.decodeIfPresent(FoodDetails.self , forKey: .foodDetails     )
        variation       = try values.decodeIfPresent([String].self    , forKey: .variation       )
        addOns          = try values.decodeIfPresent([AddOns].self    , forKey: .addOns          )
        discountOnFood  = try values.decodeIfPresent(Int.self         , forKey: .discountOnFood  )
        discountType    = try values.decodeIfPresent(String.self      , forKey: .discountType    )
        quantity        = try values.decodeIfPresent(Int.self         , forKey: .quantity        )
        taxAmount       = try values.decodeIfPresent(Int.self         , forKey: .taxAmount       )
        variant         = try values.decodeIfPresent(String.self      , forKey: .variant         )
        createdAt       = try values.decodeIfPresent(String.self      , forKey: .createdAt       )
        updatedAt       = try values.decodeIfPresent(String.self      , forKey: .updatedAt       )
        itemCampaignId  = try values.decodeIfPresent(String.self      , forKey: .itemCampaignId  )
        totalAddOnPrice = try values.decodeIfPresent(Int.self         , forKey: .totalAddOnPrice )
        
    }
    
    init() {
        
    }
    
}

struct FoodDetails: Codable {
    
    var id                    : Int?             = nil
    var name                  : String?          = nil
    var appimage              : String?          = nil
    var description           : String?          = nil
    var image                 : String?          = nil
    var categoryId            : Int?             = nil
    var categoryIds           : [CategoryIds]?   = []
    var variations            : [Variations]?    = []
    var addOns                : [AddOns]?        = []
    var attributes            : [String]?        = []
    var choiceOptions         : [ChoiceOptions]? = []
    var price                 : Int?             = nil
    var tax                   : Int?             = nil
    var taxType               : String?          = nil
    var discount              : Int?             = nil
    var discountType          : String?          = nil
    var availableTimeStarts   : String?          = nil
    var availableTimeEnds     : String?          = nil
    var veg                   : Int?             = nil
    var status                : Int?             = nil
    var restaurantId          : Int?             = nil
    var createdAt             : String?          = nil
    var updatedAt             : String?          = nil
    var orderCount            : String?          = nil
    var avgRating             : Int?             = nil
    var ratingCount           : Int?             = nil
    var tprice                : String?          = nil
    var timing                : String?          = nil
    var applogo               : String?          = nil
    var appcoverlogo          : String?          = nil
    var restaurantName        : String?          = nil
    var restaurantDiscount    : Int?             = nil
    var restaurantOpeningTime : String?          = nil
    var restaurantClosingTime : String?          = nil
    var scheduleOrder         : Bool?            = nil
    
    enum CodingKeys: String, CodingKey {
        
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
        case tprice                = "tprice"
        case timing                = "timing"
        case applogo               = "applogo"
        case appcoverlogo          = "appcoverlogo"
        case restaurantName        = "restaurant_name"
        case restaurantDiscount    = "restaurant_discount"
        case restaurantOpeningTime = "restaurant_opening_time"
        case restaurantClosingTime = "restaurant_closing_time"
        case scheduleOrder         = "schedule_order"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id                    = try values.decodeIfPresent(Int.self             , forKey: .id                    )
        name                  = try values.decodeIfPresent(String.self          , forKey: .name                  )
        appimage              = try values.decodeIfPresent(String.self          , forKey: .appimage              )
        description           = try values.decodeIfPresent(String.self          , forKey: .description           )
        image                 = try values.decodeIfPresent(String.self          , forKey: .image                 )
        categoryId            = try values.decodeIfPresent(Int.self             , forKey: .categoryId            )
        categoryIds           = try values.decodeIfPresent([CategoryIds].self   , forKey: .categoryIds           )
        variations            = try values.decodeIfPresent([Variations].self    , forKey: .variations            )
        addOns                = try values.decodeIfPresent([AddOns].self        , forKey: .addOns                )
        attributes            = try values.decodeIfPresent([String].self        , forKey: .attributes            )
        choiceOptions         = try values.decodeIfPresent([ChoiceOptions].self , forKey: .choiceOptions         )
        price                 = try values.decodeIfPresent(Int.self             , forKey: .price                 )
        tax                   = try values.decodeIfPresent(Int.self             , forKey: .tax                   )
        taxType               = try values.decodeIfPresent(String.self          , forKey: .taxType               )
        discount              = try values.decodeIfPresent(Int.self             , forKey: .discount              )
        discountType          = try values.decodeIfPresent(String.self          , forKey: .discountType          )
        availableTimeStarts   = try values.decodeIfPresent(String.self          , forKey: .availableTimeStarts   )
        availableTimeEnds     = try values.decodeIfPresent(String.self          , forKey: .availableTimeEnds     )
        veg                   = try values.decodeIfPresent(Int.self             , forKey: .veg                   )
        status                = try values.decodeIfPresent(Int.self             , forKey: .status                )
        restaurantId          = try values.decodeIfPresent(Int.self             , forKey: .restaurantId          )
        createdAt             = try values.decodeIfPresent(String.self          , forKey: .createdAt             )
        updatedAt             = try values.decodeIfPresent(String.self          , forKey: .updatedAt             )
        orderCount            = try values.decodeIfPresent(String.self          , forKey: .orderCount            )
        avgRating             = try values.decodeIfPresent(Int.self             , forKey: .avgRating             )
        ratingCount           = try values.decodeIfPresent(Int.self             , forKey: .ratingCount           )
        tprice                = try values.decodeIfPresent(String.self          , forKey: .tprice                )
        timing                = try values.decodeIfPresent(String.self          , forKey: .timing                )
        applogo               = try values.decodeIfPresent(String.self          , forKey: .applogo               )
        appcoverlogo          = try values.decodeIfPresent(String.self          , forKey: .appcoverlogo          )
        restaurantName        = try values.decodeIfPresent(String.self          , forKey: .restaurantName        )
        restaurantDiscount    = try values.decodeIfPresent(Int.self             , forKey: .restaurantDiscount    )
        restaurantOpeningTime = try values.decodeIfPresent(String.self          , forKey: .restaurantOpeningTime )
        restaurantClosingTime = try values.decodeIfPresent(String.self          , forKey: .restaurantClosingTime )
        scheduleOrder         = try values.decodeIfPresent(Bool.self            , forKey: .scheduleOrder         )
        
    }
    
    init() {
        
    }
    
}

