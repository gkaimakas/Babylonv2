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
    
    /// Fetches a list of comments for the post with `postId` from the backend.
    ///
    ///
    /// - parameters:
    ///   - postId: The id of the post the comments are attached.
    func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError>
}

public final class CommentRemoteProvider: RemoteProvider, CommentRemoteProviderProtocol {
    
    /// Fetches a list of comments for the post with `postId` from the backend.
    ///
    ///
    /// - parameters:
    ///   - postId: The id of the post the comments are attached.
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError> {
        return network
            .data(from: try! CommentRouter.fetchComments(postId: postId).asURLRequest())
            .decode(Array<Comment>.self)
    }
}
