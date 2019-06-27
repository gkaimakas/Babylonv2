//
//  NetworkProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import BabylonCommon
import ReactiveSwift

public protocol Network {
    func data(from request: URLRequest) -> SignalProducer<Data, RemoteProviderError>
}

extension SessionManager: Network {
    public func data(from request: URLRequest) -> SignalProducer<Data, RemoteProviderError> {
        return self
            .request(request)
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .data()
    }
}
