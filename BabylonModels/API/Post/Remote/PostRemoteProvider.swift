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
    func fetchPostList(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError>
    
    func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError>
}

public class PostRemoteProvider: RemoteProvider, PostRemoteProviderProtocol {
    public func fetchPostList(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError> {
        
        return network
            .data(from: try! PostRouter.fetchPosts(page, limit).asURLRequest())
            .decode([Post].self)
    }
    
    public func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError> {
        return network
            .data(from: try! PostRouter.fetchPost(id).asURLRequest())
            .decode(Post.self)
    }
}


