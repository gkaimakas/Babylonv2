//
//  Post.swift
//  BabylonModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//


import BabylonModels

extension Post {
    static func mocked() -> Post {
        return Post(id: Int(arc4random_uniform(10_000)),
             userId: Int(arc4random_uniform(10_000)),
             title: "\(Int(arc4random_uniform(10_000)))",
            body: "\(Int(arc4random_uniform(10_000)))")
    }
}
