//
//  PostProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import BabylonCommon
import ReactiveSwift

public protocol PostProviderProtocol: class {
    func fetchPost(id: Int, strategy: FetchStrategy<Post>) -> SignalProducer<FetchResult<Post>, ProviderError>
    func fetchPosts(page: Int, limit: Int, strategy: FetchStrategy<[Post]>) -> SignalProducer<FetchResult<[Post]>, ProviderError>
}

public final class PostProvider: PostProviderProtocol {
    let remote: PostRemoteProviderProtocol
    let local: PostLocalProviderProtocol
    
    public init(remote: PostRemoteProviderProtocol,
                local: PostLocalProviderProtocol) {
        
        self.remote = remote
        self.local = local
    }
    
    public func fetchPost(id: Int, strategy: FetchStrategy<Post>) -> SignalProducer<FetchResult<Post>, ProviderError> {
        
        switch strategy {
        case .local:
            return local
                .fetchPost(id: id)
                .mapError { ProviderError.local($0) }
                .map { FetchResult<Post>.local($0) }
            
        case .remote:
            return remote
                .fetchPost(id: id)
                .mapError { ProviderError.remote($0) }
                .flatMap(.latest) { result -> SignalProducer<Post, ProviderError> in
                    return self.local
                        .save(post: result)
                        .mapError { ProviderError.local($0) }
                }
                .map { FetchResult<Post>.remote($0) }
            
        case .merge:
            return SignalProducer.merge(
                fetchPost(id: id, strategy: .local),
                fetchPost(id: id, strategy: .remote)
            )
            
        case .conditional(let remoteFetch):
            return fetchPost(id: id, strategy: .local)
                .flatMap(.latest) { result -> SignalProducer<FetchResult<Post>, ProviderError> in
                    if remoteFetch(result.value) {
                        return self.fetchPost(id: id, strategy: .remote)
                    }
                    
                    return SignalProducer(value: result)
            }
        }
    }
    
    public func fetchPosts(page: Int, limit: Int, strategy: FetchStrategy<[Post]>) -> SignalProducer<FetchResult<[Post]>, ProviderError> {
        switch strategy {
        case .local:
            return local
                .fetchPosts(page: page, limit: limit)
                .mapError { ProviderError.local($0) }
                .map { FetchResult.local($0) }
            
        case .remote:
            return remote
                .fetchPostList(page: page, limit: limit)
                .mapError { ProviderError.remote($0) }
                .flatMap(.latest) { result -> SignalProducer<[Post], ProviderError> in
                    return self.local
                        .save(posts: result)
                        .mapError { ProviderError.local($0) }
                }
                .map { FetchResult.remote($0) }
            
        case .merge:
            return SignalProducer.merge(
                fetchPosts(page: page, limit: limit, strategy: .local),
                fetchPosts(page: page, limit: limit, strategy: .remote)
            )
            
        case .conditional(let remoteFetch):
            return fetchPosts(page: page, limit: limit, strategy: .local)
                .flatMap(.latest) { result -> SignalProducer<FetchResult<[Post]>, ProviderError> in
                    if remoteFetch(result.value) {
                        return self.fetchPosts(page: page, limit: limit, strategy: .remote)
                    }
                    
                    return SignalProducer(value: result)
            }
        }
    }
}
