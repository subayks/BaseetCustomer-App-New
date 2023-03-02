//
//  ReplaceUserModel.swift
//  Baseet App
//
//  Created by Subendran on 18/09/22.
//

import Foundation

struct ReplaceUserModel: Codable {
    
    var message: String? = nil
    var errors : [ErrorMap]? = nil

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case errors = "errors"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self , forKey: .message )
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
    }
    
    init() {
        
    }
    
}
