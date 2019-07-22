//
//  OnTheMapClient.swift
//  OntheMap
//
//  Created by Apple on 22/07/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation

class OnTheMapClient {
    //as this app does not support persistence so below struct will be used
    struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1"
        
        case login
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseUrl + "session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
