//
//  PostViewModel.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import BabylonModels
import BabylonCommon
import ReactiveSwift

public class PostViewModel {
    private let _comments: MutableProperty<[CommentViewModel]>
    
    public let id: Property<Int>
    public let title: Property<String?>
    public let body: Property<String?>
    public let user: UserViewModel
    
    public let comments: Property<[CommentViewModel]>
    
    public let fetchComments: Action<FetchStrategy<[Comment]>, [CommentViewModel], ProviderError>
    public let forceFetchComments: Action<Void, [CommentViewModel], ProviderError>
    
    public init(post: Post,
                user: User,
                providerBundle: ProviderBundleProtocol) {
        id = Property(value: post.id)
        title = Property(value: post.title)
        body = Property(value: post.body)
        self.user = UserViewModel(user: user)
        
        _comments = MutableProperty([])
        comments = Property(_comments)
        
        let isFetchCommentsEnabled = comments.map { $0.count == 0 }
        
        fetchComments = Action(enabledIf: isFetchCommentsEnabled) { strategy -> SignalProducer<[CommentViewModel], ProviderError> in
            
            return providerBundle
                .comment
                .fetchComments(postId: post.id, strategy: strategy)
                .map { $0.value.map { CommentViewModel(comment: $0) } }
        }
        
        forceFetchComments = Action { _ -> SignalProducer<[CommentViewModel], ProviderError> in

            return providerBundle
                .comment
                .fetchComments(postId: post.id, strategy: .remote)
                .map { $0.value.map { CommentViewModel(comment: $0) } }
        }
        
        bind()
    }
    
    func bind() {
        _comments <~ Signal.merge(
            fetchComments.values,
            forceFetchComments.values
        )
    }
}

extension PostViewModel: Equatable {
    public static func ==(lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return lhs.id.value == rhs.id.value
    }
}

extension PostViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {

        hasher.combine(id.value)
        hasher.combine(title.value)
        hasher.combine(body.value)
        hasher.combine(user.id.value)
    }
}
