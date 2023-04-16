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
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case link
//        case imageUrl
//        case numberOfLessons = "number_of_lessons"
//        case numberOfTests = "number_of_tests"
//    }
}
