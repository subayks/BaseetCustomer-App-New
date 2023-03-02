//
//  AccessTokenModel.swift
//  Baseet App
//
//  Created by Subendran on 06/09/22.
//

import Foundation

struct AccessTokenModel: Codable {
    
    var accessToken: String? = nil
    var error : TokenError? = nil
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "accessToken"
        case error = "error"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self , forKey: .accessToken )
        error   = try values.decodeIfPresent(TokenError.self , forKey: .error)
    }
    
    init() {
        
    }
    
}

struct TokenError: Codable {

  var text    : String? = nil
  var nextValidRequestDate   : String? = nil
 

  enum CodingKeys: String, CodingKey {

    case text    = "text"
    case nextValidRequestDate    = "nextValidRequestDate"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

      text    = try values.decodeIfPresent(String.self , forKey: .text    )
      nextValidRequestDate   = try values.decodeIfPresent(String.self , forKey: .nextValidRequestDate)
  }

  init() {

  }

}

