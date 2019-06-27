//
//  UserViewModel.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonModels
import ReactiveSwift

public class UserViewModel {
    public let id: Property<Int>
    public let name: Property<String?>
    public let username: Property<String?>
    public let email: Property<String?>
    public let phone: Property<String?>
    public let website: Property<String?>
    public let address: AddressViewModel?
    public let company: CompanyViewModel?
    
    public init(user: User) {
        id = Property(value: user.id)
        name = Property(value: user.name)
        username = Property(value: user.username)
        email = Property(value: user.email)
        phone = Property(value: user.phone)
        website = Property(value: user.website)
        address = AddressViewModel(address: user.address)
        company = CompanyViewModel(company: user.company)
    }
}

extension UserViewModel: Equatable {
    public static func ==(lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.id.value == rhs.id.value
    }
}

extension UserViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.value)
    }
}
