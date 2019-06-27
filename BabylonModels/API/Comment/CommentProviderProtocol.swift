//
//  CommentProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//
import Foundation
import BabylonCommon
import ReactiveSwift

public protocol CommentProviderProtocol {
    func fetchComment(id: Int, strategy: FetchStrategy<Comment>) -> SignalProducer<FetchResult<Comment>, ProviderError>
    func fetchComments(postId: Int, strategy: FetchStrategy<[Comment]>) -> SignalProducer<FetchResult<[Comment]>, ProviderError>
}

public final class CommentProvider: CommentProviderProtocol {
    
    let remote: CommentRemoteProviderProtocol
    let local: CommentLocalProviderProtocol
    
    public init(remote: CommentRemoteProviderProtocol,
                local: CommentLocalProviderProtocol) {
        
        self.remote = remote
        self.local = local
    }
    
    public func fetchComment(id: Int, strategy: FetchStrategy<Comment>) -> SignalProducer<FetchResult<Comment>, ProviderError> {
        switch strategy {
        case .local:
            return local
                .fetchComment(id: id)
                .map { FetchResult.local($0) }
                .mapError { ProviderError.local($0) }
            
        case .remote:
            return remote
                .fetchComment(id: id)
                .mapError { ProviderError.remote($0) }
                .flatMap(.latest) { result -> SignalProducer<Comment, ProviderError> in
                    return self.local
                        .save(comment: result)
                        .mapError { ProviderError.local($0) }
                }
                .map { FetchResult.remote($0) }
            
        case .merge:
            return SignalProducer.merge(
                fetchComment(id: id, strategy: .local),
                fetchComment(id: id, strategy: .remote)
            )
            
        case .conditional(let remoteFetch):
            return fetchComment(id: id, strategy: .local)
                .flatMap(.latest) { result -> SignalProducer<FetchResult<Comment>, ProviderError> in
                    if remoteFetch(result.value) {
                        return self.fetchComment(id: id, strategy: .remote)
                    }
                    
                    return SignalProducer(value: result)
            }
        }
    }
    
    public func fetchComments(postId: Int, strategy: FetchStrategy<[Comment]>) -> SignalProducer<FetchResult<[Comment]>, ProviderError> {
        switch strategy {
        case .local:
            return local
                .fetchComments(postId: postId)
                .map { FetchResult.local($0) }
                .mapError { ProviderError.local($0) }
            
        case .remote:
            return remote
                .fetchComments(postId: postId)
                .mapError { ProviderError.remote($0) }
                .flatMap(.latest) { result -> SignalProducer<[Comment], ProviderError> in
                    return self.local
                        .save(comments: result)
                        .mapError { ProviderError.local($0) }
                }
                .map { FetchResult.remote($0) }
            
        case .merge:
            return SignalProducer.merge(
                fetchComments(postId: postId, strategy: .local),
                fetchComments(postId: postId, strategy: .remote)
            )
            
        case .conditional(let remoteFetch):
            return fetchComments(postId: postId, strategy: .local)
                .flatMap(.latest) { result -> SignalProducer<FetchResult<[Comment]>, ProviderError> in
                    if remoteFetch(result.value) {
                        return self.fetchComments(postId: postId, strategy: .remote)
                    }
                    
                    return SignalProducer(value: result)
            }
            
        }
    }
}
