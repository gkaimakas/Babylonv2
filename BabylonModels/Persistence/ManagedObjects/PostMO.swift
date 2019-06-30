//
//  PostMO.swift
//  BabylonModels
//
//  Created by George Kaimakas on 27/06/2019.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation

class PostMO: NSManagedObject {
    static func requestFetchAllPosts() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        return request
    }

    static func requestFetchPost(id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.predicate = NSPredicate(format: "id == \(id)")
        return request
    }
    
    static func requestFetchPagedPosts(page: Int, limit: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.fetchLimit = limit
        request.fetchBatchSize = limit
        request.fetchOffset = page * limit
        request.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true)
        ]
        return request
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    
    func inflate(post: Post) {
        self.id = Int64(post.id)
        self.userId = Int64(post.userId)
        self.title = post.title
        self.body = post.body
    }
}
