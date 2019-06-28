//
//  MockedPostProvider.swift
//  BabylonViewModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import BabylonModels
import ReactiveSwift

class MockedPostProvider: PostProviderProtocol {
    let mockFetchPosts = MockAction<FetchResult<[Post]>>.echo
    let mockFetchPostById = MockAction<FetchResult<Post>>.echo
    
    init() { }
    
    func fetchPost(id: Int, strategy: FetchStrategy<Post>) -> SignalProducer<FetchResult<Post>, ProviderError> {
        return SignalProducer(mockFetchPostById.values)
            .decomposeResult()
            .take(first: 1)
    }
    
    func fetchPosts(page: Int, limit: Int, strategy: FetchStrategy<[Post]>) -> SignalProducer<FetchResult<[Post]>, ProviderError> {
        return SignalProducer(mockFetchPosts.values)
            .decomposeResult()
            .take(first: 1)
    }
}
