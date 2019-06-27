//
//  AddressViewModel.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import BabylonModels
import ReactiveSwift

public class AddressViewModel {
    
    public let street: Property<String?>
    public let suite: Property<String?>
    public let city: Property<String?>
    public let zipCode: Property<String?>
    public let location: LocationViewModel?
    
    public init(address: Address) {
        street = Property(value: address.street)
        suite = Property(value: address.suite)
        city = Property(value: address.city)
        zipCode = Property(value: address.zipCode)
        location = LocationViewModel(location: address.location)
    }
    
    public convenience init?(address: Address?) {
        guard let address = address else {
            return nil
        }
        
        self.init(address: address)
    }
    
}
