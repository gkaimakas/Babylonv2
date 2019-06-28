//
//  PostRouter.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Alamofire
import Foundation

enum PostRouter {
    case fetchPosts(Int, Int)
    case fetchPost(Int)
}

extension PostRouter: URLRequestConvertible {
    var httpMethod: Alamofire.HTTPMethod {
        return .get
    }
    
    var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .fetchPosts(_, _):
            return URLEncoding.default
        case .fetchPost(_):
            return URLEncoding.default
        }
    }
    
    var requestConfiguration: (path: String, parameters: [String: AnyObject]?) {
        switch self {
        case .fetchPosts(let page, let limit):
            return (
                path: "https://jsonplaceholder.typicode.com/posts",
                parameters: [
                    "_page": page as AnyObject,
                    "_limit": limit as AnyObject
                ]
            )
            
        case .fetchPost(let id):
            return (
                path: "https://jsonplaceholder.typicode.com/posts/\(id)",
                parameters: nil
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let result = self.requestConfiguration
        
        let url = Foundation.URL(string: result.path)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = self.httpMethod.rawValue
        
        let request = try encoding.encode(urlRequest, with: result.parameters)
        return request
    }
}
