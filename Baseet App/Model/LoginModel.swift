//
//  LoginModel.swift
//  Baseet App
//
//  Created by Subendran on 02/09/22.
//

import Foundation

struct LoginModel: Codable {
    
    var token: String? = nil
    var is_phone_verified: Int? = nil
    var user_id: Int? = nil
    var errors : [ErrorMap]? = nil
    var message: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case is_phone_verified = "is_phone_verified"
        case user_id = "user_id"
        case errors = "errors"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self , forKey: .token )
        is_phone_verified   = try values.decodeIfPresent(Int.self , forKey: .is_phone_verified)
        user_id = try values.decodeIfPresent(Int.self , forKey: .user_id)
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
    init() {
        
    }
    
}

