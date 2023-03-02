//
//  CouponModel.swift
//  Baseet App
//
//  Created by Subendran on 20/09/22.
//

import Foundation

struct CouponModel: Codable {
    
    var data       : [CouponItem]?   = []
    var errors : [ErrorMap]? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case data       = "data"
        case errors = "errors"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data   = try values.decodeIfPresent([CouponItem].self   , forKey: .data)
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
    }
    
    init() {
        
    }
}

struct CouponItem: Codable {
    
    var id           : Int?    = nil
    var title        : String? = nil
    var code         : String? = nil
    var startDate    : String? = nil
    var expireDate   : String? = nil
    var minPurchase  : Int?    = nil
    var maxDiscount  : Int?    = nil
    var discount     : Int?    = nil
    var discountType : String? = nil
    var couponType   : String? = nil
    var limit        : Int?    = nil
    var status       : String? = nil
    var createdAt    : String? = nil
    var updatedAt    : String? = nil
    var data         : String? = nil
    var totalUses    : String? = nil
    var logo         : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case id           = "id"
        case title        = "title"
        case code         = "code"
        case startDate    = "start_date"
        case expireDate   = "expire_date"
        case minPurchase  = "min_purchase"
        case maxDiscount  = "max_discount"
        case discount     = "discount"
        case discountType = "discount_type"
        case couponType   = "coupon_type"
        case limit        = "limit"
        case status       = "status"
        case createdAt    = "created_at"
        case updatedAt    = "updated_at"
        case data         = "data"
        case totalUses    = "total_uses"
        case logo         = "logo"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id           = try values.decodeIfPresent(Int.self    , forKey: .id           )
        title        = try values.decodeIfPresent(String.self , forKey: .title        )
        code         = try values.decodeIfPresent(String.self , forKey: .code         )
        startDate    = try values.decodeIfPresent(String.self , forKey: .startDate    )
        expireDate   = try values.decodeIfPresent(String.self , forKey: .expireDate   )
        minPurchase  = try values.decodeIfPresent(Int.self    , forKey: .minPurchase  )
        maxDiscount  = try values.decodeIfPresent(Int.self    , forKey: .maxDiscount  )
        discount     = try values.decodeIfPresent(Int.self    , forKey: .discount     )
        discountType = try values.decodeIfPresent(String.self , forKey: .discountType )
        couponType   = try values.decodeIfPresent(String.self , forKey: .couponType   )
        limit        = try values.decodeIfPresent(Int.self    , forKey: .limit        )
        status       = try values.decodeIfPresent(String.self , forKey: .status       )
        createdAt    = try values.decodeIfPresent(String.self , forKey: .createdAt    )
        updatedAt    = try values.decodeIfPresent(String.self , forKey: .updatedAt    )
        data         = try values.decodeIfPresent(String.self , forKey: .data         )
        totalUses    = try values.decodeIfPresent(String.self , forKey: .totalUses    )
        logo         = try values.decodeIfPresent(String.self , forKey: .logo         )
        
    }
    
    init() {
        
    }
    
}
