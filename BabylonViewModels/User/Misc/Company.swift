//
//  Company.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import BabylonModels
import ReactiveSwift

public class CompanyViewModel {
    public let name: Property<String?>
    public let catchPhrase: Property<String?>
    public let bs: Property<String?>
    
    public init(company: Company) {
        name = Property(value: company.name)
        catchPhrase = Property(value: company.catchPhrase)
        bs = Property(value: company.bs)
    }
    
    public convenience init?(company: Company?) {
        guard let company = company else {
            return nil
        }
        
        self.init(company: company)
    }
}
