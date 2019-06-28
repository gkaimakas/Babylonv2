//
//  UserRemoteProviderSpec.swift
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

public class UserRemoteProviderSpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        let mockedNetwork = MockedNetwork()
        let repo = UserRemoteProvider(network: mockedNetwork)
        
        describe("fetcuUser(id:_)"){
            it("should fetch a user on valid data") {
                let data = NSDataAsset(name: "fetch_user_by_id", bundle: Bundle(for: type(of: self)))!.data

                var user: User? = nil
                var error: RemoteProviderError? = nil
                
                repo.fetchUser(id: 0)
                    .startWithResult({ (result) in
                        switch result {
                        case let .success(value):
                            user = value
                        case let .failure(value):
                            error = value
                        }
                    })
                
                mockedNetwork
                    .mockData
                    .apply(success: data)
                    .start()
                
                expect(user).toEventuallyNot(beNil())
                expect(error).toEventually(beNil())
                
            }
        }
    }
}
