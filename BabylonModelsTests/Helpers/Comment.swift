//
//  Comment.swift
//  BabylonModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonModels

extension Comment {
    static func mocked() -> Comment {
        
        return Comment(postId: Int(arc4random_uniform(10_000)),
                       id: Int(arc4random_uniform(10_000)),
                       name: "\(Int(arc4random_uniform(10_000)))",
            email: "\(Int(arc4random_uniform(10_000)))",
            body: "\(Int(arc4random_uniform(10_000)))")
    }
}
