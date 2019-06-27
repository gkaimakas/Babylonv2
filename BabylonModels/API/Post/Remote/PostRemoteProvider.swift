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
    
    func fetchPost(id: Int) -> SignalProducer<Post?, RemoteProviderError>
}

public class PostRemoteProvider: RemoteProvider, PostRemoteProviderProtocol {
    public func fetchPostList(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError> {
        
        return sessionManager
            .request(PostRouter.fetchPosts(page, limit))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .data()
            .decode([Post].self)
    }
    
    public func fetchPost(id: Int) -> SignalProducer<Post?, RemoteProviderError> {
        
        return sessionManager
            .request(PostRouter.fetchPost(id))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .data()
            .decode(Post?.self)
    }
    
}


