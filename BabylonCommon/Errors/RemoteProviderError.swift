//
//  RemoteProviderError.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public enum RemoteProviderError: Swift.Error {
    case request(Int)
    case decode(NSError)
}

extension RemoteProviderError: Equatable {
    public static func ==(lhs: RemoteProviderError, rhs: RemoteProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.request(let statusA), .request(let statusB)): return statusA == statusB
        case (.decode(let errorA), .decode(let errorB)): return errorA == errorB
        default: return false
        }
    }
}
