//
//  NotificationModel.swift
//  Baseet App
//
//  Created by Subendran on 26/09/22.
//

import Foundation

struct NotificationModel: Codable {
    
    var notifications       : [NotificationDataModel]?   = []
    var errors : [ErrorMap]? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case notifications = "notifications"
        case errors = "errors"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notifications   = try values.decodeIfPresent([NotificationDataModel].self   , forKey: .notifications)
        errors   = try values.decodeIfPresent([ErrorMap].self , forKey: .errors)
    }
    
    init() {
        
    }
}

struct NotificationDataModel: Codable {

  var id            : Int?    = nil
  var data          : NotioficationData?   = NotioficationData()
  var status        : String? = nil
  var userId        : String? = nil
  var vendorId      : String? = nil
  var deliveryManId : String? = nil
  var createdAt     : String? = nil
  var updatedAt     : String? = nil

  enum CodingKeys: String, CodingKey {

    case id            = "id"
    case data          = "data"
    case status        = "status"
    case userId        = "user_id"
    case vendorId      = "vendor_id"
    case deliveryManId = "delivery_man_id"
    case createdAt     = "created_at"
    case updatedAt     = "updated_at"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id            = try values.decodeIfPresent(Int.self    , forKey: .id            )
    data          = try values.decodeIfPresent(NotioficationData.self   , forKey: .data          )
    status        = try values.decodeIfPresent(String.self , forKey: .status        )
    userId        = try values.decodeIfPresent(String.self , forKey: .userId        )
    vendorId      = try values.decodeIfPresent(String.self , forKey: .vendorId      )
    deliveryManId = try values.decodeIfPresent(String.self , forKey: .deliveryManId )
    createdAt     = try values.decodeIfPresent(String.self , forKey: .createdAt     )
    updatedAt     = try values.decodeIfPresent(String.self , forKey: .updatedAt     )
 
  }

  init() {

  }

}

struct NotioficationData: Codable {

  var title       : String? = nil
  var description : String? = nil
  var orderId     : Int?    = nil
  var image       : String? = nil
  var type        : String? = nil

  enum CodingKeys: String, CodingKey {

    case title       = "title"
    case description = "description"
    case orderId     = "order_id"
    case image       = "image"
    case type        = "type"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    title       = try values.decodeIfPresent(String.self , forKey: .title       )
    description = try values.decodeIfPresent(String.self , forKey: .description )
    orderId     = try values.decodeIfPresent(Int.self    , forKey: .orderId     )
    image       = try values.decodeIfPresent(String.self , forKey: .image       )
    type        = try values.decodeIfPresent(String.self , forKey: .type        )
 
  }

  init() {

  }

}
