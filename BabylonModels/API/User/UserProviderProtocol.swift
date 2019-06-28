//
//  UserProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import BabylonCommon
import ReactiveSwift

public protocol UserProviderProtocol: class {
    func fetchUser(id: Int, strategy: FetchStrategy<User?>) -> SignalProducer<FetchResult<User?>, ProviderError>
}

public final class UserProvider: UserProviderProtocol {
    
    let remote: UserRemoteProviderProtocol
    let local: UserLocalProviderProtocol
    
    public init(remote: UserRemoteProviderProtocol,
                local: UserLocalProviderProtocol) {
        
        self.remote = remote
        self.local = local
    }
    
    public func fetchUser(id: Int, strategy: FetchStrategy<User?>) -> SignalProducer<FetchResult<User?>, ProviderError> {
        switch strategy {
        case .local:
            return local
                .fetchUser(id: id)
                .map { FetchResult.local($0) }
                .mapError { ProviderError.local($0) }
            
        case .remote:
            return remote
                .fetchUser(id: id)
                .mapError { ProviderError.remote($0) }
                .flatMap(.latest) { result -> SignalProducer<User, ProviderError> in
                    return self.local
                        .save(user: result)
                        .mapError { ProviderError.local($0) }
                }
                .map { FetchResult.remote($0) }
            
        case .merge:
            return SignalProducer.merge(
                fetchUser(id: id, strategy: .local),
                fetchUser(id: id, strategy: .remote)
            )
            
        case .conditional(let remoteFetch):
            return fetchUser(id: id, strategy: .local)
                .flatMap(.latest) { result -> SignalProducer<FetchResult<User?>, ProviderError> in
                    if remoteFetch(result.value) {
                        return self.fetchUser(id: id, strategy: .remote)
                    }
                    
                    return SignalProducer(value: result)
            }
        }
    }
}
