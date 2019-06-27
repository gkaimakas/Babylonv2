//
//  Location.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public struct Location {
    public let latitude: Double
    public let longitude: Double
    
    public init?(latitude: String,
                longitude: String) {
        guard let lat = Double(latitude),
            let long = Double(longitude) else {
                return nil
        }
        
        self.latitude = lat
        self.longitude = long
    }
    
    public init(latitude: Double,
                longitude: Double) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

extension Location: Codable { }

extension Location: Equatable {
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}

extension Location: Hashable { }
