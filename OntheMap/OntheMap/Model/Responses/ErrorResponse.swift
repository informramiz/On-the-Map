//
//  ErrorResponse.swift
//  OntheMap
//
//  Created by Apple on 22/07/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
struct ErrorResponse: Codable {
    
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return ""
    }
}
