
import Foundation

struct EditTaskModel : Codable {
	let status : Int?
	let msg : String?
	let task : Data?

	enum CodingKeys: String, CodingKey {
		case status = "status"
		case msg = "msg"
		case task = "task"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		msg = try values.decodeIfPresent(String.self, forKey: .msg)
		task = try values.decodeIfPresent(Data.self, forKey: .task)
	}

}
