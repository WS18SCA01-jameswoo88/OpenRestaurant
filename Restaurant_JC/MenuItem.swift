//
//  MenuItem.swift
//  Restaurant_JC
//
//  Created by James Chun on 3/20/19.
//  Copyright © 2019 James Chun. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var category: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey { // Protocol CodingKey insists that the names of case must match property names
        case id
        case name
        case description
        case price
        case category
        case imageURL = "image_url"
    }
    
    //because we don't have any optional properties, computer writes the init method for us in the background and uses the CodingKeys in the .decode method. We won't use the CodingKeys ourselves.
}

struct MenuItems: Codable {
    let items: [MenuItem]
}
