//
//  ZoneModel.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import Foundation

struct ZoneModel: Codable {
    
    var zoneId       : Int?   = nil
    var errors : [ErrorMap]? = nil
    
    enum CodingKeys: String, CodingKey {
        case zoneId       = "zone_id"
        case errors = "errors"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        zoneId   = try values.decodeIfPresent(Int.self   , forKey: .zoneId)
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
    }
    
    init() {
        
    }
}
