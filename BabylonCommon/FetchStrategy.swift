//
//  FetchStrategy.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

/// Describes how data should be fetched
public enum FetchStrategy<T> {
    public typealias RemoteFetchCondition = (T) -> Bool
    
    /// Data should be fetched from `local` (on device) storage.
    case local
    
    /// Data should be fetched from the `backend`.
    case remote
    
    /// Data should be fetched first from `local` storage and then from the backend
    case merge
    
    /// Data should be fetched first from `local` storage. Then if the result of `RemoteFetchCondition` is true
    /// data should be fetched from the backend.
    case conditional(RemoteFetchCondition)
}

extension FetchStrategy: Equatable {
    public static func ==(lhs: FetchStrategy, rhs: FetchStrategy) -> Bool {
        switch (lhs, rhs) {
        case (.local, .local): return true
        case (.remote, .remote): return true
        case (.merge, .merge): return true
        case (.conditional, .conditional): return true
        default:
            return false
        }
    }
}
