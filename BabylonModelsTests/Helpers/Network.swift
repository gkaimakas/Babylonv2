//
//  Network.swift
//  BabylonModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import BabylonModels
import ReactiveSwift


final class MockedNetwork: Network {
    let mockData = Action<Result<Data, RemoteProviderError>, Result<Data, RemoteProviderError>, Never>.echo
    
    init() {
        
    }
    
    func data(from request: URLRequest) -> SignalProducer<Data, RemoteProviderError> {
        return SignalProducer(mockData.values)
            .decomposeResult()
            .take(first: 1)
    }
}

extension Network {
    var mocked: MockedNetwork {
        return MockedNetwork()
    }
}
