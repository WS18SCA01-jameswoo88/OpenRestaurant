//
//  IntermediaryModels.swift
//  Restaurant_JC
//
//  Created by James Chun on 3/20/19.
//  Copyright © 2019 James Chun. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
