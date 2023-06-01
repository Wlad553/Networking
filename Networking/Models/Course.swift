//
//  Course.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import Foundation

struct Course: Decodable {
    let id: Int? // optional на случай, если не будет данных в файле json
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case imageUrl
        case numberOfLessons = "number_of_lessons"
        case numberOfTests = "number_of_tests"
    }
    
    init?(json: [String: Any]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["number_of_lessons"] as? Int
        let numberOfTests = json["number_of_tests"] as? Int
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
    }
    
    static func getArray(from jsonArray: Any) -> [Course]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        return jsonArray.compactMap { jsonObject in
            Course(json: jsonObject)
        }
    }
}
