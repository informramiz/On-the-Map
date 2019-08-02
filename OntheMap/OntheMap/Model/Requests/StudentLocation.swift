//
//  StudentLocation.swift
//  OntheMap
//
//  Created by Ramiz Raja on 02/08/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

extension StudentLocation {
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    func toCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func toMKPointAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = toCoordinate2D()
        annotation.title = fullName
        annotation.subtitle = mediaURL
        return annotation
    }
}
