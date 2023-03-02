//
//  UpdateCartModel.swift
//  Baseet App
//
//  Created by Subendran on 15/08/22.
//

import Foundation

struct UpdateCartModel: Codable {
    
    var message    : String? = nil
    var order_id : Int? = nil
    var total_ammount: Int? = nil
    var errors : [ErrorMap]? = nil

 enum CodingKeys: String, CodingKey {
        
        case message    = "message"
        case order_id = "order_id"
        case total_ammount = "total_ammount"
        case errors = "errors"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message    = try values.decodeIfPresent(String.self    , forKey: .message    )
        order_id    = try values.decodeIfPresent(Int.self    , forKey: .order_id    )
        total_ammount    = try values.decodeIfPresent(Int.self    , forKey: .total_ammount    )
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors   )
    }
}
