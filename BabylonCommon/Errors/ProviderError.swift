//
//  ProviderError.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public enum ProviderError: Swift.Error {
    case unknown
    case remote(RemoteProviderError)
    case local(LocalProviderError)
}

extension ProviderError: Equatable {
    public static func ==(lhs: ProviderError, rhs: ProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.local(let a), .local(let b)):
            return a == b
        case (.remote(let a), .remote(let b)):
            return a == b
        default:
            return false
        }
    }
}
