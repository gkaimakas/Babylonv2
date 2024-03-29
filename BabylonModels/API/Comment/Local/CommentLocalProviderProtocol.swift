//
//  CommentLocalProviderProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//
import CoreData
import Foundation
import BabylonCommon
import ReactiveSwift

public protocol CommentLocalProviderProtocol {
    /// Fetches the comments attached to postId from the local storage.
    ///
    /// - parameters:
    ///   - postId: The id of the post the comments are attached.
    func fetchComments(postId: Int) -> SignalProducer<[Comment], LocalProviderError>
    
    /// Saves or updates a list of comments.
    ///
    /// - parameters:
    ///   - comments: The comments to save or update.
    func save(comments: [Comment]) -> SignalProducer<[Comment], LocalProviderError>
    
    /// Removes all comments.
    func dropAll() -> SignalProducer<Void, LocalProviderError>
}

public final class CommentLocalProvider: LocalProvider, CommentLocalProviderProtocol {
    
    /// Fetches the comments attached to postId from the local storage.
    ///
    /// - parameters:
    ///   - postId: The id of the post the comments are attached.
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], LocalProviderError> {
        return SignalProducer<[CommentMO], Error> { () -> Result<[CommentMO], Error> in
            return Result<[CommentMO], Error>(catching: { () -> [CommentMO] in
                return try self.container
                    .fetchObjects(type: CommentMO.self,
                                  request: CommentMO.requestFetchComments(postId: postId))
            })}
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
            .map { $0.map { Comment($0) } }
    }
    
    /// Saves or updates a list of comments.
    ///
    /// - parameters:
    ///   - comments: The comments to save or update.
    public func save(comments: [Comment]) -> SignalProducer<[Comment], LocalProviderError> {
        return SignalProducer<[CommentMO], Error> { () -> Result<[CommentMO], Error> in
            return Result<[CommentMO], Error>(catching: { () -> [CommentMO] in
                let list = try comments.map { comment -> CommentMO in
                    guard let existing = try self.container.fetchObjects(type: CommentMO.self, request: CommentMO.requestFetchComment(id: comment.id)).first else {
                        
                        let new = self
                            .container
                            .newObject(type: CommentMO.self)
                        new.inflate(comment: comment)
                        return new
                    }
                    
                    existing.inflate(comment: comment)
                    return existing
                }
                
                try self
                    .container
                    .viewContext.save()
                
                return list
            })
            }
            .map { $0.map { Comment($0) } }
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
    }
    
    /// Removes all comments.
    public func dropAll() -> SignalProducer<Void, LocalProviderError> {
        return SignalProducer<Void, Error> { () -> Result<Void, Error> in
            return Result<Void, Error>.init(catching: {
                try self.container
                    .deleteObjects(type: CommentMO.self, request: CommentMO.requestFetchAllComments())
            })}
            .mapError { LocalProviderError.persistenceFailure($0 as NSError) }
    }
}
