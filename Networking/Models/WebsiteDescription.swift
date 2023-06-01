//
//  WebsiteDescription.swift
//  Networking
//
//  Created by Vladyslav Petrenko on 16/04/2023.
//

import Foundation

struct WebsiteDescription: Decodable {
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
