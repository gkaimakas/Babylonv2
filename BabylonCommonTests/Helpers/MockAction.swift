//
//  MockAction.swift
//  BabylonCommonTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonCommon
import ReactiveSwift

typealias MockResponse<T> = Result<T, ProviderError>

/// Shorthand for actions that have the same input and output
typealias EchoAction<Value, Error: Swift.Error> = Action<Value, Value, Error>

/// Shorthand for actions that are used to mock responses in providers
typealias MockAction<Value> = EchoAction<MockResponse<Value>, Never>

extension Action where Input: ResultProtocol, Error == Never {
    func apply(success value: Input.Value) -> SignalProducer<Output, ActionError<Error>> {
        return self.apply(Result<Input.Value, Input.Error>(success: value) as! Input)
    }
    
    func apply(failure error: Input.Error) -> SignalProducer<Output, ActionError<Error>> {
        return self.apply(Result<Input.Value, Input.Error>(failure: error) as! Input)
    }
}

public protocol ResultProtocol {
    associatedtype Value
    associatedtype Error: Swift.Error
    
    var value: Result<Value, Error> { get }
}

extension Result: ResultProtocol {
    public var value: Result<Success, Failure> {
        return self
    }
}

extension SignalProducer where Value: ResultProtocol, Error == Never {
    func decomposeResult() -> SignalProducer<Value.Value, Value.Error> {
        return self.promoteError(Value.Error.self)
            .flatMap(.latest) { result -> SignalProducer<Value.Value, Value.Error> in
                switch result.value {
                case .success(let value):
                    return SignalProducer<Value.Value, Value.Error>(value: value)
                    
                case .failure(let error):
                    return SignalProducer<Value.Value, Value.Error>(error: error)
                }
        }
    }
}
