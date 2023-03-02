/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation


struct PopularShopListModel: Codable {

  var Popurestaurants : [PopulerRestaurent]? = []

  enum CodingKeys: String, CodingKey {

    case Popurestaurants = "PopularRestaurants"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

      Popurestaurants = try values.decodeIfPresent([PopulerRestaurent].self , forKey: .Popurestaurants )
 
  }

  init() {

  }

}





struct PopulerRestaurent : Codable {
	let id : Int?
	let name : String?
	let phone : String?
	let email : String?
	let logo : String?
	let latitude : String?
	let longitude : String?
	let address : String?
	let footer_text : String?
	let minimum_order : Int?
	let comission : String?
	let schedule_order : Bool?
	let opening_time : String?
	let closeing_time : String?
	let status : Int?
	let vendor_id : Int?
	let created_at : String?
	let updated_at : String?
	let free_delivery : Bool?
	let cover_photo : String?
	let applogo : String?
	let appcoverlogo : String?
	let delivery : Bool?
	let take_away : Bool?
	let food_section : Bool?
	let tax : Int?
	let zone_id : Int?
	let reviews_section : Bool?
	let active : Bool?
	let off_day : String?
	let self_delivery_system : Int?
	let pos_system : Bool?
	let delivery_charge : Int?
	let delivery_time : String?
	let veg : Int?
	let non_veg : Int?
	let order_count : String?
	let total_order : String?
	let req_id : String?
	let open : Int?
	let orders_count : String?
	let avg_rating : Int?
	let rating_count  : Int?
	let gst_status : Bool?
	let gst_code : String?
	let discount : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case phone = "phone"
		case email = "email"
		case logo = "logo"
		case latitude = "latitude"
		case longitude = "longitude"
		case address = "address"
		case footer_text = "footer_text"
		case minimum_order = "minimum_order"
		case comission = "comission"
		case schedule_order = "schedule_order"
		case opening_time = "opening_time"
		case closeing_time = "closeing_time"
		case status = "status"
		case vendor_id = "vendor_id"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case free_delivery = "free_delivery"
		case cover_photo = "cover_photo"
		case applogo = "applogo"
		case appcoverlogo = "appcoverlogo"
		case delivery = "delivery"
		case take_away = "take_away"
		case food_section = "food_section"
		case tax = "tax"
		case zone_id = "zone_id"
		case reviews_section = "reviews_section"
		case active = "active"
		case off_day = "off_day"
		case self_delivery_system = "self_delivery_system"
		case pos_system = "pos_system"
		case delivery_charge = "delivery_charge"
		case delivery_time = "delivery_time"
		case veg = "veg"
		case non_veg = "non_veg"
		case order_count = "order_count"
		case total_order = "total_order"
		case req_id = "req_id"
		case open = "open"
		case orders_count = "orders_count"
		case avg_rating = "avg_rating"
		case rating_count  = "rating_count "
		case gst_status = "gst_status"
		case gst_code = "gst_code"
		case discount = "discount"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		logo = try values.decodeIfPresent(String.self, forKey: .logo)
		latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		footer_text = try values.decodeIfPresent(String.self, forKey: .footer_text)
		minimum_order = try values.decodeIfPresent(Int.self, forKey: .minimum_order)
		comission = try values.decodeIfPresent(String.self, forKey: .comission)
		schedule_order = try values.decodeIfPresent(Bool.self, forKey: .schedule_order)
		opening_time = try values.decodeIfPresent(String.self, forKey: .opening_time)
		closeing_time = try values.decodeIfPresent(String.self, forKey: .closeing_time)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		vendor_id = try values.decodeIfPresent(Int.self, forKey: .vendor_id)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		free_delivery = try values.decodeIfPresent(Bool.self, forKey: .free_delivery)
		cover_photo = try values.decodeIfPresent(String.self, forKey: .cover_photo)
		applogo = try values.decodeIfPresent(String.self, forKey: .applogo)
		appcoverlogo = try values.decodeIfPresent(String.self, forKey: .appcoverlogo)
		delivery = try values.decodeIfPresent(Bool.self, forKey: .delivery)
		take_away = try values.decodeIfPresent(Bool.self, forKey: .take_away)
		food_section = try values.decodeIfPresent(Bool.self, forKey: .food_section)
		tax = try values.decodeIfPresent(Int.self, forKey: .tax)
		zone_id = try values.decodeIfPresent(Int.self, forKey: .zone_id)
		reviews_section = try values.decodeIfPresent(Bool.self, forKey: .reviews_section)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		off_day = try values.decodeIfPresent(String.self, forKey: .off_day)
		self_delivery_system = try values.decodeIfPresent(Int.self, forKey: .self_delivery_system)
		pos_system = try values.decodeIfPresent(Bool.self, forKey: .pos_system)
		delivery_charge = try values.decodeIfPresent(Int.self, forKey: .delivery_charge)
		delivery_time = try values.decodeIfPresent(String.self, forKey: .delivery_time)
		veg = try values.decodeIfPresent(Int.self, forKey: .veg)
		non_veg = try values.decodeIfPresent(Int.self, forKey: .non_veg)
		order_count = try values.decodeIfPresent(String.self, forKey: .order_count)
		total_order = try values.decodeIfPresent(String.self, forKey: .total_order)
		req_id = try values.decodeIfPresent(String.self, forKey: .req_id)
		open = try values.decodeIfPresent(Int.self, forKey: .open)
		orders_count = try values.decodeIfPresent(String.self, forKey: .orders_count)
		avg_rating = try values.decodeIfPresent(Int.self, forKey: .avg_rating)
		rating_count  = try values.decodeIfPresent(Int.self, forKey: .rating_count )
		gst_status = try values.decodeIfPresent(Bool.self, forKey: .gst_status)
		gst_code = try values.decodeIfPresent(String.self, forKey: .gst_code)
		discount = try values.decodeIfPresent(String.self, forKey: .discount)
	}

}
