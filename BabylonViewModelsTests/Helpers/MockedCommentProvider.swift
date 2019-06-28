//
//  MockedCommentProvider.swift
//  BabylonViewModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import BabylonModels
import ReactiveSwift

class MockedCommentProvider: CommentProviderProtocol {
    let mockFetchComments = MockAction<FetchResult<[Comment]>>.echo
    let mockFetchCommentById = MockAction<FetchResult<Comment>>.echo
    
    init() { }
    
    func fetchComment(id: Int, strategy: FetchStrategy<Comment>) -> SignalProducer<FetchResult<Comment>, ProviderError> {
        return SignalProducer(mockFetchCommentById.values)
            .decomposeResult()
            .take(first: 1)
    }
    
    func fetchComments(postId: Int, strategy: FetchStrategy<[Comment]>) -> SignalProducer<FetchResult<[Comment]>, ProviderError> {
        return SignalProducer(mockFetchComments.values)
            .decomposeResult()
            .take(first: 1)
    }
}
