//
//  SignalProducer+DataResponse.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//
import Alamofire
import Foundation
import BabylonCommon
import ReactiveSwift

public extension SignalProducer where Value == DataResponse<Data>, Error == RemoteProviderError {
    func data() -> SignalProducer<Data, RemoteProviderError> {
        return attemptMap { response -> Swift.Result<Data, RemoteProviderError> in
            switch response.result {
            case .success(let value):
                return Swift.Result.success(value)
            case .failure(_):
                return Swift.Result.failure(RemoteProviderError.request(response.response?.statusCode ?? 400))
            }
        }
    }
}
