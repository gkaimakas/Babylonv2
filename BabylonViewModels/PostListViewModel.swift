//
//  PostListViewModel.swift
//  BabylonViewModels
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//
import BabylonCommon
import BabylonModels
import ReactiveSwift

public class PostListViewModel {
    public static let limit = 20
    
    private let _posts: MutableProperty<[PostViewModel]>
    
    private let page: Property<Int>
    private let hasMoreEntries = MutableProperty<Bool>(true)
    
    public var posts: Property<[PostViewModel]>
    
    public let fetchPosts: Action<FetchStrategy<[Post]>, [PostViewModel], ProviderError>
    public let forceFetchPosts: Action<Void, [PostViewModel], ProviderError>
    
    public init(providerBundle: ProviderBundleProtocol) {
        _posts = MutableProperty([])
        posts = _posts
            .map { Array(Set<PostViewModel>($0)) }
            .map { $0.sorted(by: { $0.id.value < $1.id.value }) }
        
        page = _posts
            .map { ceil(Double($0.count)/Double(PostListViewModel.limit)) }
            .map { Int($0) }

        let fetchPostsState = page.combineLatest(with: hasMoreEntries)
        fetchPosts = Action(state: fetchPostsState, enabledIf: { $0.1 }) { (state, strategy) in
            
            let userStrategy: FetchStrategy<User> = strategy
                .map({ _ in { _ in true }})
            
            let newPage = state.0 + 1
            
            return providerBundle
                .post
                .fetchPosts(page: newPage,
                            limit: PostListViewModel.limit,
                            strategy: strategy)
                .map { $0.value }
                .flatten()
                .flatMap(.concat) { post in
                    return providerBundle
                        .user
                        .fetchUser(id: post.userId,strategy: .conditional { $0 == nil })
                        .filterMap { $0.value }
                        .map { (post: post, user: $0) }
                }
                .map { PostViewModel(post: $0.post, user: $0.user, providerBundle: providerBundle) }
                .collect()
        }
        
        forceFetchPosts = Action { _ in
            return providerBundle
                .post
                .fetchPosts(page: 1,
                            limit: PostListViewModel.limit,
                            strategy: .remote)
                .map { $0.value }
                .flatten()
                .flatMap(.concat) { post in
                    return providerBundle
                        .user
                        .fetchUser(id: post.userId,strategy: .conditional { $0 == nil })
                        .filterMap { $0.value }
                        .map { (post: post, user: $0) }
                }
                .map { PostViewModel(post: $0.post, user: $0.user, providerBundle: providerBundle) }
                .collect()
        }
        
        bind()
    }
    
    func bind() {
        hasMoreEntries <~ fetchPosts
            .values
            .map { $0.count > 0 }
        
        
        _posts <~ fetchPosts
            .values
            .filterMap { [weak self] list -> [PostViewModel]? in
                guard let self = self else {
                    return nil
                }
                return self._posts.value + list
            }
        
        _posts <~ forceFetchPosts
            .values
        
    }
}
