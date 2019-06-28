//
//  UserLocalProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import BabylonCommon
import ReactiveSwift

public protocol UserLocalProviderProtocol {
    
    /// Fetches a user by the id from the local storage.
    ///
    /// - parameters:
    ///   - id: The id of the user to fetch.
    func fetchUser(id: Int) -> SignalProducer<User?, LocalProviderError>
    
    /// Saves or updates a user.
    ///
    /// - parameters:
    ///   - user: The user to save or update.
    func save(user: User) -> SignalProducer<User, LocalProviderError>
    
    /// Removes all users.
    func dropAll() -> SignalProducer<Void, LocalProviderError>
}

public final class UserLocalProvider: LocalProvider, UserLocalProviderProtocol {
    
    /// Fetches a user by the id from the local storage.
    ///
    /// - parameters:
    ///   - id: The id of the user to fetch.
    public func fetchUser(id: Int) -> SignalProducer<User?, LocalProviderError> {
        
        return SignalProducer<UserMO?, Error> { () -> Result<UserMO?, Error> in
            return Result<UserMO?, Error>(catching: { () -> UserMO? in
                return try self.container
                    .fetchObjects(type: UserMO.self,
                                  request: UserMO.requestFetchUser(id: id))
                    .first
            })}
            .mapError { .persistenceFailure($0 as NSError) }
            .map { User($0) }
    }
    
    /// Saves or updates a user.
    ///
    /// - parameters:
    ///   - user: The user to save or update.
    public func save(user: User) -> SignalProducer<User, LocalProviderError> {
        return SignalProducer<UserMO, Error> { () -> Result<UserMO, Error> in
            return Result<UserMO, Error>(catching: { () -> UserMO in
                guard let existing = try self.container.fetchObjects(type: UserMO.self, request: UserMO.requestFetchUser(id: user.id)).first else {
                    
                    let new = self
                        .container
                        .newObject(type: UserMO.self)
                    new.inflate(user: user)
                    try self
                        .container
                        .viewContext.save()
                    return new
                }
                
                existing.inflate(user: user)
                return existing
            })}
            .filterMap { User($0) }
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
    }
    
    /// Removes all users.
    public func dropAll() -> SignalProducer<Void, LocalProviderError> {
        return SignalProducer<Void, Error> { () -> Result<Void, Error> in
            return Result<Void, Error>.init(catching: {
                try self.container
                    .deleteObjects(type: UserMO.self, request: UserMO.requestFetchAllUsers())
            })}
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
    }
    
    
}
