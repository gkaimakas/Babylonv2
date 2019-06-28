//
//  UserRemoteProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//
import Alamofire
import BabylonCommon
import ReactiveSwift

public protocol UserRemoteProviderProtocol {
    /// Fetches a user by the id from the backend.
    ///
    /// - parameters:
    ///   - id: The id of the user to fetch.
    func fetchUser(id: Int) -> SignalProducer<User, RemoteProviderError>
}

public class UserRemoteProvider: RemoteProvider, UserRemoteProviderProtocol {
    /// Fetches a user by the id from the backend.
    ///
    /// - parameters:
    ///   - id: The id of the user to fetch.
    public func fetchUser(id: Int) -> SignalProducer<User, RemoteProviderError> {
        return network
            .data(from: try! UserRouter.fetchUser(id: id).asURLRequest())
            .decode(User.self)
    }
}
