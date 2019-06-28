//
//  UserLocalRepositorySpec.swift
//  BabylonModelsTests
//
//  Created by George Kaimakas on 28/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import Nimble
import Quick
import ReactiveSwift
import BabylonCommon
@testable import BabylonModels

public class UserLocalRepositorySpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        let container = DataContainer(name: "UserLocalRepositorySpec")
        let repo = UserLocalProvider(container: container)
        
        describe("save(user:_)"){
            it("should save a user") {
                var user: User! = nil
                let newUser = User.mocked()
                
                repo.save(user: newUser)
                    .startWithResult({ (result: Result<User, LocalProviderError>) in
                        switch result {
                        case .success(let value):
                            user = value
                        case .failure(_):
                            user = nil
                        }
                    })
                
                expect(user).toEventuallyNot(beNil())
                if let user = user {
                    expect(user.id).to(equal(newUser.id))
                    expect(user.name).to(equal(newUser.name))
                    expect(user.email).to(equal(newUser.email))
                }
            }
        }
    }
}
