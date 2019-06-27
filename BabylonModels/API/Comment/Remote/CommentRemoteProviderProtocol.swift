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
        return network
            .data(from: try! CommentRouter.fetchComment(id: id).asURLRequest())
            .decode(Comment.self)
    }
    
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError> {
        return network
            .data(from: try! CommentRouter.fetchComments(postId: postId).asURLRequest())
            .decode(Array<Comment>.self)
    }
}
