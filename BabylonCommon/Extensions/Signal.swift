//
//  Signal.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//


import ReactiveSwift

public extension Signal where Value == Data, Error == RemoteProviderError {
    func decode<T: Decodable>(_ t: T.Type, decoder: JSONDecoder = JSONDecoder()) -> Signal<T, RemoteProviderError> {
        return attemptMap { data -> Result<T, Error> in
            do {
                return Result(success: try decoder.decode(t, from: data))
            } catch let error as NSError {
                return Result(failure: RemoteProviderError.decode(error))
            }
        }
    }
}

public extension SignalProducer where Value == Data, Error == RemoteProviderError {
    func decode<T: Decodable>(_ t: T.Type, decoder: JSONDecoder = JSONDecoder()) -> SignalProducer<T, RemoteProviderError> {
        return lift { $0.decode(t, decoder: decoder) }
    }
}
