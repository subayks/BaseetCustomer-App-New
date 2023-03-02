//
//  CategoryListModel.swift
//  Baseet App
//
//  Created by Subendran on 03/08/22.
//


import Foundation

struct CategoryListModel: Codable {

  var id        : Int?    = nil
  var name      : String? = nil
  var image     : String? = nil
  var appimage  : String? = nil
  var parentId  : Int?    = nil
  var position  : Int?    = nil
  var status    : Int?    = nil
  var createdAt : String? = nil
  var updatedAt : String? = nil
  var priority  : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case id        = "id"
    case name      = "name"
    case image     = "image"
    case appimage  = "appimage"
    case parentId  = "parent_id"
    case position  = "position"
    case status    = "status"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case priority  = "priority"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id        = try values.decodeIfPresent(Int.self    , forKey: .id        )
    name      = try values.decodeIfPresent(String.self , forKey: .name      )
    image     = try values.decodeIfPresent(String.self , forKey: .image     )
    appimage  = try values.decodeIfPresent(String.self , forKey: .appimage  )
    parentId  = try values.decodeIfPresent(Int.self    , forKey: .parentId  )
    position  = try values.decodeIfPresent(Int.self    , forKey: .position  )
    status    = try values.decodeIfPresent(Int.self    , forKey: .status    )
    createdAt = try values.decodeIfPresent(String.self , forKey: .createdAt )
    updatedAt = try values.decodeIfPresent(String.self , forKey: .updatedAt )
    priority  = try values.decodeIfPresent(Int.self    , forKey: .priority  )
 
  }

  init() {

  }

}
