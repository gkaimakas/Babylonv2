//
//  User.swift
//  BabylonModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonModels

extension User {
    static func mocked() -> User {
        let location = Location(latitude: 20,
                                longitude: 23)
        return User(id: Int(arc4random_uniform(10_000)),
             name: "\(arc4random_uniform(1000))",
            username: "\(arc4random_uniform(1000))",
            email: "\(arc4random_uniform(1000))",
            phone: "\(arc4random_uniform(1000))",
            website: "\(arc4random_uniform(1000))",
            address: Address(street: "\(arc4random_uniform(1000))",
                suite: "\(arc4random_uniform(1000))",
                city: "\(arc4random_uniform(1000))",
                zipCode: "\(arc4random_uniform(1000))",
                location: location),
            company: Company(name: "\(arc4random_uniform(1000))",
                catchPhrase: "\(arc4random_uniform(1000))",
                bs: "\(arc4random_uniform(1000))"))
    }
}
