//
//  PostViewModelSpec.swift
//  BabylonViewModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//


import Foundation
import Nimble
import Quick
import ReactiveSwift
import BabylonCommon
import BabylonModels
@testable import BabylonViewModels

public class PostViewModelSpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        let mockedComment = MockedCommentProvider()
        let bundle = ProviderBundle(comment: mockedComment,
                                    post: MockedPostProvider(),
                                    user: MockedUserProvider())
        
        let postViewModel = PostViewModel(post: Post.mocked(),
                                          user: User.mocked(),
                                          providerBundle: bundle)
        
        describe("fetchComments"){
            beforeEach {
                postViewModel._comments.value = []
            }
            
            it("should update the comments ") {
                
                postViewModel
                    .fetchComments
                    .apply(.remote)
                    .start()
                
                mockedComment
                    .mockFetchComments
                    .apply(success: FetchResult<[Comment]>.remote((0...9).map { _ in Comment.mocked() }))
                    .start()
                
                expect(postViewModel.comments.value.count).toEventually(equal(10))
            }
        }
    }
}
