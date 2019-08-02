//
//  UserDataResponse.swift
//  OntheMap
//
//  Created by Ramiz Raja on 02/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation

struct UserDataResponse: Codable {
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
    }
}

//struct User: Codable {
//    let lastName: String
//    
//    enum CodingKeys: String, CodingKey {
//        case lastName = "last_name"
//    }
//}
