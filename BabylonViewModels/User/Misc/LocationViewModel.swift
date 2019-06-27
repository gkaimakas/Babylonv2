//
//  LocationViewModel.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//
import Foundation
import BabylonModels
import ReactiveSwift

public class LocationViewModel {
    public let latitude: Property<Double>
    public let longitude: Property<Double>
    
    public init(location: Location) {
        latitude = Property(value: location.latitude)
        longitude = Property(value: location.longitude)
    }
    
    public convenience init?(location: Location?) {
        guard let location = location else {
            return nil
        }
        
        self.init(location: location)
    }
}
