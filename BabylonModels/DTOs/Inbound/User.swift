//
//  User.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public struct User {
    public let id: Int
    public let name: String?
    public let username: String?
    public let email: String?
    public let phone: String?
    public let website: String?
    public let address: Address?
    public let company: Company?
    
    public init(id: Int,
                name: String?,
                username: String?,
                email: String?,
                phone: String?,
                website: String?,
                address: Address?,
                company: Company?) {
        
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company
    }
}

extension User {
    init(_ mo: UserMO) {
        self.id = Int(mo.id)
        self.name = mo.name
        self.username = mo.username
        self.email = mo.email
        self.phone = mo.phone
        self.website = mo.website
        
        self.address = Address(street: mo.address_street,
                               suite: mo.address_suite,
                               city: mo.address_city,
                               zipCode: mo.address_zipCode,
                               location: Location(latitude: mo.address_geo_lat as? Double,
                                                  longitude: mo.address_geo_lng as? Double)
        )
        
        self.company = Company(name: mo.company_name,
                               catchPhrase: mo.company_catchPhrase,
                               bs: mo.company_catchPhrase)
    }
}

extension User: Codable { }

extension User: Equatable {
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User: Hashable { }
