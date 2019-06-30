//
//  Comment.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public struct Comment {
    
    public let postId: Int
    public let id: Int
    public let name: String?
    public let email: String?
    public let body: String?
    
    public init(postId: Int,
                id: Int,
                name: String?,
                email: String?,
                body: String?) {
        
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}

extension Comment {
    init(_ mo: CommentMO) {
        postId = Int(mo.postId)
        id = Int(mo.id)
        name = mo.name
        email = mo.email
        body = mo.body
    }
}

extension Comment: Codable { }

extension Comment: Hashable { }
