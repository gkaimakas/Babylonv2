//
//  LocalProviderError.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public enum LocalProviderError: Swift.Error  {
    case notFound
    case alreadyExists
    case persistenceFailure(NSError)
}

extension LocalProviderError: Equatable {
    public static func ==(lhs: LocalProviderError, rhs: LocalProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound): return true
        case (.alreadyExists, .alreadyExists):  return true
        case (.persistenceFailure(let errorA), .persistenceFailure(let errorB)): return errorA == errorB
        default: return false
        }
    }
}
