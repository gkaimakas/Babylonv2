//
//  PostRemoteProvider.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import ReactiveSwift

public protocol PostRemoteProviderProtocol: RemoteProviderProtocol {
    /// Fetches a list of posts from the backend using pagination.
    ///
    /// - parameters:
    ///   - page: pagination parameter.
    ///   - limit: pagination parameter.
    func fetchPostList(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError>
    
    func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError>
}

public class PostRemoteProvider: RemoteProvider, PostRemoteProviderProtocol {
    /// Fetches a list of posts from the backend using pagination.
    ///
    /// - parameters:
    ///   - page: pagination parameter.
    ///   - limit: pagination parameter.
    public func fetchPostList(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError> {
        return network
            .data(from: try! PostRouter.fetchPosts(page, limit).asURLRequest())
            .decode([Post].self)
    }
    
    /// Fetches a post by id from the backend.
    ///
    /// - parameters:
    ///   - id: The id of the post to fetch.
    public func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError> {
        return network
            .data(from: try! PostRouter.fetchPost(id).asURLRequest())
            .decode(Post.self)
    }
}


