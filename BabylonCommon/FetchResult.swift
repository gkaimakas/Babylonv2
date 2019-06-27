//
//  FetchResult.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//


/// Describes the origin of data
public enum FetchResult<T> {
    /// Data was fetched from `local` storage
    case local(T)
    
    /// Data was fetched from the `backend`
    case remote(T)
    
    public var value: T {
        switch self {
        case .local(let result):
            return result
        case .remote(let result):
            return result
        }
    }
    
    public var isLocal: Bool {
        switch self {
        case .local:
            return true
            
        case .remote:
            return false
        }
    }
    
    public var isRemote: Bool {
        switch self {
        case .local:
            return false
            
        case .remote:
            return true
        }
    }
    
    public func map<U>(_ transform: (T) throws -> U) rethrows -> FetchResult<U> {
        switch self {
        case .local(let value):
            return FetchResult<U>.local(try transform(value))
            
        case .remote(let value):
            return FetchResult<U>.remote(try transform(value))
        }
    }
}
