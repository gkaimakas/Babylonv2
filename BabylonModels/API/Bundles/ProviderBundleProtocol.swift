//
//  ProviderBundleProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

/// Since the project relies on multiple providers for data fetching, it is best
/// to not polute the initializer with many arguments.
/// `ProviderBundleProtocol` bundles all providers in the app so the user only
/// supplies on argument instead of 3.
public protocol ProviderBundleProtocol {
    var comment: CommentProviderProtocol { get }
    var post: PostProviderProtocol { get }
    var user: UserProviderProtocol { get }
}

/// Default implementation of `ProviderBundleProtocol`.
public final class ProviderBundle: ProviderBundleProtocol {
    public let comment: CommentProviderProtocol
    public let post: PostProviderProtocol
    public let user: UserProviderProtocol
    
    public init(comment: CommentProviderProtocol,
                post: PostProviderProtocol,
                user: UserProviderProtocol) {
        
        self.comment = comment
        self.post = post
        self.user = user
    }
}
