//
//  CustomerInfoModel.swift
//  Baseet App
//
//  Created by Subendran on 23/09/22.
//

import Foundation

struct CustomerInfoModel: Codable {
    var errors : [ErrorMap]? = nil
    var id              : Int?    = nil
    var fName           : String? = nil
    var lName           : String? = nil
    var phone           : String? = nil
    var email           : String? = nil
    var image           : String? = nil
    var isPhoneVerified : Int?    = nil
    var emailVerifiedAt : String? = nil
    var createdAt       : String? = nil
    var updatedAt       : String? = nil
    var cmFirebaseToken : String? = nil
    var status          : String? = nil
    var orderCount      : Int?    = nil
    var loginMedium     : String? = nil
    var socialId        : String? = nil
    var zoneId          : String? = nil
    var memberSinceDays : Int?    = nil
    var appImage : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case id              = "id"
        case fName           = "f_name"
        case lName           = "l_name"
        case phone           = "phone"
        case email           = "email"
        case image           = "image"
        case isPhoneVerified = "is_phone_verified"
        case emailVerifiedAt = "email_verified_at"
        case createdAt       = "created_at"
        case updatedAt       = "updated_at"
        case cmFirebaseToken = "cm_firebase_token"
        case status          = "status"
        case orderCount      = "order_count"
        case loginMedium     = "login_medium"
        case socialId        = "social_id"
        case zoneId          = "zone_id"
        case memberSinceDays = "member_since_days"
        case errors = "errors"
        case appImage = "app_image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id              = try values.decodeIfPresent(Int.self    , forKey: .id              )
        fName           = try values.decodeIfPresent(String.self , forKey: .fName           )
        lName           = try values.decodeIfPresent(String.self , forKey: .lName           )
        phone           = try values.decodeIfPresent(String.self , forKey: .phone           )
        email           = try values.decodeIfPresent(String.self , forKey: .email           )
        image           = try values.decodeIfPresent(String.self , forKey: .image           )
        isPhoneVerified = try values.decodeIfPresent(Int.self    , forKey: .isPhoneVerified )
        emailVerifiedAt = try values.decodeIfPresent(String.self , forKey: .emailVerifiedAt )
        createdAt       = try values.decodeIfPresent(String.self , forKey: .createdAt       )
        updatedAt       = try values.decodeIfPresent(String.self , forKey: .updatedAt       )
        cmFirebaseToken = try values.decodeIfPresent(String.self , forKey: .cmFirebaseToken )
        status          = try values.decodeIfPresent(String.self , forKey: .status          )
        orderCount      = try values.decodeIfPresent(Int.self    , forKey: .orderCount      )
        loginMedium     = try values.decodeIfPresent(String.self , forKey: .loginMedium     )
        socialId        = try values.decodeIfPresent(String.self , forKey: .socialId        )
        zoneId          = try values.decodeIfPresent(String.self , forKey: .zoneId          )
        memberSinceDays = try values.decodeIfPresent(Int.self    , forKey: .memberSinceDays )
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
        appImage          = try values.decodeIfPresent(String.self , forKey: .appImage          )
    }
    
    init() {
        
    }
    
}
