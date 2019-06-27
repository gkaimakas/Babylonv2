//
//  CommentRemoteProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import Foundation
import BabylonCommon
import ReactiveSwift

public protocol CommentRemoteProviderProtocol: RemoteProvider {
    func fetchComment(id: Int) -> SignalProducer<Comment, RemoteProviderError>
    func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError>
}

public final class CommentRemoteProvider: RemoteProvider, CommentRemoteProviderProtocol {
    public func fetchComment(id: Int) -> SignalProducer<Comment, RemoteProviderError> {
        return sessionManager
            .request(CommentRouter.fetchComment(id: id))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .data()
            .decode(Comment.self)
    }
    
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError> {
        return sessionManager
            .request(CommentRouter.fetchComments(postId: postId))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .data()
            .decode(Array<Comment>.self)
    }
}
