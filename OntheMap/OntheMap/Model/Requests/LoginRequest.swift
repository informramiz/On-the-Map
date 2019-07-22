//
//  LoginRequest.swift
//  OntheMap
//
//  Created by Apple on 22/07/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
struct LoginRequest: Codable {
    let udacity: UdacityCredentials
    
    init(username: String, password: String) {
        udacity = UdacityCredentials(username: username, password: password)
    }
}
