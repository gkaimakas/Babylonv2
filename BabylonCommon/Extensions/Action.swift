//
//  Action.swift
//  BabylonCommon
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import ReactiveSwift

extension Action where Input == Output {
    
    /// Initializes an `Action` that echoes its input.
    ///
    /// When the `Action` is asked to start the execution with an input value, a unit of
    /// work — represented by a `SignalProducer` — would be created by invoking
    /// `execute` with the input value.
    public static var echo: Action {
        return Action.echo(enabledIf: Property<Bool>(value: true))
    }
    
    /// Initializes an `Action` that echoes its input and would be conditionally enabled.
    ///
    /// When the `Action` is asked to start the execution with an input value, a unit of
    /// work — represented by a `SignalProducer` — would be created by invoking
    /// `execute` with the input value.
    ///
    /// - parameters:
    ///   - isEnabled: A property which determines the availability of the `Action`.
    ///   - execute: A closure that produces a unit of work, as `SignalProducer`, to
    ///              be executed by the `Action`.
    public static func echo<IsEnabled: PropertyProtocol>(enabledIf isEnabled: IsEnabled) -> Action where IsEnabled.Value == Bool {
        return Action(enabledIf: isEnabled, execute: { value -> SignalProducer<Input, Error> in
            return SignalProducer(value: value)
        })
    }
}

extension Action {
    
    public static var empty: Action<Input, Output, Error> {
        return Action { _ in SignalProducer.empty }
    }
    
    public static func value(_ result: Output) -> Action<Input, Output, Error> {
        return Action { _ in SignalProducer<Output, Error>(value: result) }
    }
    
    public func map<NewInput, NewOutput, NewError: Swift.Error>(input transformInput: @escaping (NewInput) -> Input,
                                                                output transformOutput: @escaping (Output) -> NewOutput,
                                                                error transformError: @escaping (Error) -> NewError)
        -> Action<NewInput, NewOutput, NewError> {
            return Action<NewInput, NewOutput, NewError>(enabledIf: isEnabled,
                                                         execute: { [weak self] (newInput) -> SignalProducer<NewOutput, NewError> in
                                                            guard let self = self else {
                                                                return SignalProducer.empty
                                                            }
                                                            
                                                            return self
                                                                .apply(transformInput(newInput))
                                                                .map { transformOutput($0) }
                                                                .flatMapError({ (actionError) -> SignalProducer<NewOutput, NewError> in
                                                                    switch actionError {
                                                                    case .disabled:
                                                                        return SignalProducer.empty
                                                                    case .producerFailed(let err):
                                                                        return SignalProducer(error: transformError(err))
                                                                    }
                                                                })
            })
    }
    
    public func mapInput<NewInput>(input transform: @escaping (NewInput) -> Input) -> Action<NewInput, Output, Error> {
        return map(input: transform,
                   output: { $0 },
                   error: { $0 })
    }
    
    public func mapOutput<NewOutput>(output transform: @escaping (Output) -> NewOutput) -> Action<Input, NewOutput, Error> {
        return map(input: { $0 },
                   output: transform,
                   error: { $0 })
    }
    
    public func mapError<NewError: Swift.Error>(error transform: @escaping (Error) -> NewError) -> Action<Input, Output, NewError> {
        return map(input: { $0 },
                   output: { $0 },
                   error: transform)
    }
    
    public func ignoreOutput() -> Action<Input, Void, Error> {
        return mapOutput(output: { _ in () })
    }
    
    public func ignoreError() ->  Action<Input, Output, Never> {
        return Action<Input, Output, Never>(enabledIf: isEnabled,
                                              execute: { [weak self] (newInput) -> SignalProducer<Output, Never> in
                                                guard let self = self else {
                                                    return SignalProducer.empty
                                                }
                                                
                                                return self
                                                    .apply(newInput)
                                                    .flatMapError({ (actionError) -> SignalProducer<Output, Never> in
                                                        switch actionError {
                                                        case .disabled:
                                                            return SignalProducer.empty
                                                        case .producerFailed:
                                                            return SignalProducer.empty
                                                        }
                                                    })
        })
    }
}

extension Action where Input == Void {
    public func ignoreInput<NewInput>() -> Action<NewInput, Output, Error> {
        return map(input: { _ in () },
                   output: { $0 },
                   error: { $0 })
    }
}
