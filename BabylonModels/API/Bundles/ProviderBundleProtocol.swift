//
//  ProviderBundleProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public protocol ProviderBundleProtocol {
    var comment: CommentProviderProtocol { get }
    var post: PostProviderProtocol { get }
    var user: UserProviderProtocol { get }
}

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
