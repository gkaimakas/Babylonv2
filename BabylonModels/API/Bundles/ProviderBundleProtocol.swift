//
//  ProviderBundleProtocol.swift
//  BabylonModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public protocol ProviderBundleProtocol {
    var comment: CommentProvider { get }
    var post: PostProvider { get }
}
