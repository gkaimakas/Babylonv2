//
//  MockedUserProvider.swift
//  BabylonViewModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import BabylonModels
import ReactiveSwift

class MockedUserProvider: UserProviderProtocol {
    
    let mockFetchUserId = MockAction<FetchResult<User?>>.echo
    
    init() { }
    
    func fetchUser(id: Int, strategy: FetchStrategy<User?>) -> SignalProducer<FetchResult<User?>, ProviderError> {
        return SignalProducer(mockFetchUserId.values)
            .decomposeResult()
            .take(first: 1)
    }
}
