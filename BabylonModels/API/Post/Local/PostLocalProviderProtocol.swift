//
//  PostLocalProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import BabylonCommon
import ReactiveSwift

public protocol PostLocalProviderProtocol {
    /// Fetches a post by id from the local storage.
    ///
    /// - parameters:
    ///   - id: The id of the post to fetch.
    func fetchPost(id: Int) -> SignalProducer<Post, LocalProviderError>
    
    /// Fetchs a list of posts from the local storage using pagination.
    ///
    /// - parameters:
    ///   - page: pagination paramter.
    ///   - limit: pagination parameter.
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], LocalProviderError>
    
    /// Saves or updates a post.
    ///
    /// - parameters:
    ///   - post: The post to save or update.
    func save(post: Post) -> SignalProducer<Post, LocalProviderError>
    
    /// Saves or updates a list of posts.
    ///
    /// - parameters:
    ///   - posts: The posts to save or update.
    func save(posts: [Post]) -> SignalProducer<[Post], LocalProviderError>
    
    /// Removes all posts.
    func dropAll() -> SignalProducer<Void, LocalProviderError>
}

public class PostLocalProvider: LocalProvider, PostLocalProviderProtocol {
    /// Fetches a post by id from the local storage.
    ///
    /// - parameters:
    ///   - id: The id of the post to fetch.
    public func fetchPost(id: Int) -> SignalProducer<Post, LocalProviderError> {
        return SignalProducer<PostMO?, Error> { () -> Result<PostMO?, Error> in
            return Result<PostMO?, Error>(catching: { () -> PostMO? in
                return try self
                    .container
                    .fetchObjects(type: PostMO.self, request: PostMO.requestFetchPost(id: id)).first
            })}
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
            .flatMap(.latest) { value -> SignalProducer<PostMO, LocalProviderError> in
                guard let value = value else {
                    return SignalProducer<PostMO, LocalProviderError>(error: .notFound)
                }
                
                return SignalProducer<PostMO, LocalProviderError>(value: value)
            }
            .map { Post($0) }
        
    }
    
    /// Fetchs a list of posts from the local storage using pagination.
    ///
    /// - parameters:
    ///   - page: pagination paramter.
    ///   - limit: pagination parameter.
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], LocalProviderError> {
        return SignalProducer<[PostMO], Error> { () -> Result<[PostMO], Error> in
            return Result<[PostMO], Error>(catching: { () -> [PostMO] in
                return try self.container
                    .fetchObjects(type: PostMO.self,
                                  request: PostMO.requestFetchPagedPosts(page: page-1, limit: limit))
            })}
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
            .map { $0.map { Post($0) } }
            .on(value: { print("local", $0.count) })
    }
    
    /// Saves or updates a post.
    ///
    /// - parameters:
    ///   - post: The post to save or update.
    public func save(post: Post) -> SignalProducer<Post, LocalProviderError> {
        return SignalProducer<PostMO, Error> { () -> Result<PostMO, Error> in
            return Result<PostMO, Error>(catching: { () -> PostMO in
                guard let existing = try self.container.fetchObjects(type: PostMO.self, request: PostMO.requestFetchPost(id: post.id)).first else {
                    
                    let new = self
                        .container
                        .newObject(type: PostMO.self)
                    new.inflate(post: post)
                    try self
                        .container
                        .viewContext.save()
                    return new
                }
            
                existing.inflate(post: post)
                try self
                    .container
                    .viewContext.save()
                return existing
            })
            }
            .map { Post($0) }
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
    }
    
    /// Saves or updates a list of posts.
    ///
    /// - parameters:
    ///   - posts: The posts to save or update.
    public func save(posts: [Post]) -> SignalProducer<[Post], LocalProviderError> {
        return SignalProducer<[PostMO], Error> { () -> Result<[PostMO], Error> in
            return Result<[PostMO], Error>(catching: { () -> [PostMO] in
                let list = try posts.map { post -> PostMO in
                    guard let existing = try self.container.fetchObjects(type: PostMO.self, request: PostMO.requestFetchPost(id: post.id)).first else {
                        
                        let new = self
                            .container
                            .newObject(type: PostMO.self)
                        new.inflate(post: post)
                        return new
                    }
                    
                    existing.inflate(post: post)
                    return existing
                }
                
                try self
                    .container
                    .viewContext.save()
                
                return list
            })
        }
            .map { $0.map { Post($0) } }
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
        
    }
    
    /// Removes all posts.
    public func dropAll() -> SignalProducer<Void, LocalProviderError> {
        return SignalProducer<Void, Error> { () -> Result<Void, Error> in
            return Result<Void, Error>.init(catching: {
                try self.container
                    .deleteObjects(type: PostMO.self, request: PostMO.requestFetchAllPosts())
            })}
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
    }
}
