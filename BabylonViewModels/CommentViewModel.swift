//
//  CommentViewModel.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import BabylonModels
import ReactiveSwift

public class CommentViewModel {
    public let postId: Property<Int>
    public let id: Property<Int>
    public let name: Property<String?>
    public let email: Property<String?>
    public let body: Property<String?>
    
    public init(comment: Comment) {
        self.postId = Property(value: comment.postId)
        self.id = Property(value: comment.id)
        self.name = Property(value: comment.name)
        self.email = Property(value: comment.email)
        self.body = Property(value: comment.body)
    }
    
    public convenience init?(comment: Comment?) {
        guard let comment = comment else {
            return nil
        }
        
        self.init(comment: comment)
    }
}

extension CommentViewModel: Equatable {
    public static func ==(lhs: CommentViewModel, rhs: CommentViewModel) -> Bool {
        return lhs.postId.value == rhs.postId.value
            && lhs.id.value == rhs.id.value
    }
}

extension CommentViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(postId.value)
        hasher.combine(id.value)
    }
}
