//
//  Post.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public struct Post {
    public let id: Int
    public let userId: Int
    public let title: String?
    public let body: String?
    
    public init(id: Int,
                userId: Int,
                title: String?,
                body: String?) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

extension Post: Codable { }

extension Post: Equatable {
    public static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
            && lhs.userId == rhs.userId
            && lhs.title == rhs.title
            && lhs.body == rhs.body
    }
}

extension Post: Hashable { }
