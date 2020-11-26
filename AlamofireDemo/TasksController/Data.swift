

import Foundation
struct Data : Codable {
	let id : Int?
	let user_id : Int?
	let task : String?
	let completed : Int?
	let created_at : String?
	let updated_at : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_id = "user_id"
		case task = "task"
		case completed = "completed"
		case created_at = "created_at"
		case updated_at = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		task = try values.decodeIfPresent(String.self, forKey: .task)
		completed = try values.decodeIfPresent(Int.self, forKey: .completed)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
	}

}
