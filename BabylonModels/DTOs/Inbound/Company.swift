//
//  Company.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public struct Company {
    public let name: String?
    public let catchPhrase: String?
    public let bs: String?
    
    public init(name: String?,
                catchPhrase: String?,
                bs: String?) {
        
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}

extension Company: Codable { }

extension Company: Hashable { }
