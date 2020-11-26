

import Foundation

struct GetAllTasksModel : Codable {
	let total : Int?
	let per_page : Int?
	let current_page : Int?
	let last_page : Int?
	let next_page_url : String?
	let prev_page_url : String?
	let from : Int?
	let to : Int?
	let data : [Data]?

	enum CodingKeys: String, CodingKey {
		case total = "total"
		case per_page = "per_page"
		case current_page = "current_page"
		case last_page = "last_page"
		case next_page_url = "next_page_url"
		case prev_page_url = "prev_page_url"
		case from = "from"
		case to = "to"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
		current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
		last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
		next_page_url = try values.decodeIfPresent(String.self, forKey: .next_page_url)
		prev_page_url = try values.decodeIfPresent(String.self, forKey: .prev_page_url)
		from = try values.decodeIfPresent(Int.self, forKey: .from)
		to = try values.decodeIfPresent(Int.self, forKey: .to)
		data = try values.decodeIfPresent([Data].self, forKey: .data)
	}

}
