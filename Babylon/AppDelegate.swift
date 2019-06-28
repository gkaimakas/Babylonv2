//
//  AppDelegate.swift
//  Babylon
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import BabylonModels
import BabylonViewModels
import Swinject
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let dependencyContainer = DependencyContainer()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

extension AppDelegate {
    final class DependencyContainer {
        let container: Container
        
        init() {
            container = Container()
            
            registerEphemeral()
            registerPersistent()
            
        }
        
        func resolve<Service>(_ serviceType: Service.Type) -> Service? {
            return container.resolve(serviceType)
        }
        
        
        func registerEphemeral() {
            container.register(PostListViewModel.self) { r in
                return PostListViewModel(providerBundle: r.resolve(ProviderBundleProtocol.self)!)
                }.inObjectScope(.ephemeralContainer)
        }
        
        func registerPersistent() {
            container.register(Network.self) { r in
                return SessionManager.default
                }.inObjectScope(.container)
            
            container.register(DataContainer.self) { r in
                return DataContainer(name: "Babylon")
                }.inObjectScope(.container)
            
            container.register(CommentRemoteProviderProtocol.self) { r in
                return CommentRemoteProvider(network: r.resolve(Network.self)!)
                }.inObjectScope(.container)
            
            container.register(CommentLocalProviderProtocol.self) { r in
                return CommentLocalProvider(container: r.resolve(DataContainer.self)!)
                }.inObjectScope(.container)
            
            container.register(CommentProviderProtocol.self) { r in
                return CommentProvider(remote: r.resolve(CommentRemoteProviderProtocol.self)!,
                                       local: r.resolve(CommentLocalProviderProtocol.self)!)
                }.inObjectScope(.container)
            
            container.register(PostRemoteProviderProtocol.self) { r in
                return PostRemoteProvider(network: r.resolve(Network.self)!)
                }.inObjectScope(.container)
            
            container.register(PostLocalProviderProtocol.self) { r in
                return PostLocalProvider(container: r.resolve(DataContainer.self)!)
                }.inObjectScope(.container)
            
            container.register(PostProviderProtocol.self) { r in
                return PostProvider(remote: r.resolve(PostRemoteProviderProtocol.self)!,
                                    local: r.resolve(PostLocalProviderProtocol.self)!)
                }.inObjectScope(.container)
            
            container.register(UserRemoteProviderProtocol.self) { r in
                return UserRemoteProvider(network: r.resolve(Network.self)!)
                }.inObjectScope(.container)
            
            container.register(UserLocalProviderProtocol.self) { r in
                return UserLocalProvider(container: r.resolve(DataContainer.self)!)
                }.inObjectScope(.container)
            
            container.register(UserProviderProtocol.self) { r in
                return UserProvider(remote: r.resolve(UserRemoteProviderProtocol.self)!,
                                    local: r.resolve(UserLocalProviderProtocol.self)!)
                }.inObjectScope(.container)
            
            container.register(ProviderBundleProtocol.self) { r in
                return ProviderBundle(comment: r.resolve(CommentProviderProtocol.self)!,
                                      post: r.resolve(PostProviderProtocol.self)!,
                                      user: r.resolve(UserProviderProtocol.self)!)
                }.inObjectScope(.container)
        }
    }
}


extension ObjectScope {
    static let ephemeralContainer = ObjectScope(storageFactory: PermanentStorage.init)
}

