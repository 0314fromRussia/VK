//
//  Repository.swift
//  VKlient
//
//  Created by Никита Дмитриев on 06.01.2021.
//  Copyright © 2021 Никита Дмитриев. All rights reserved.
//

import Foundation
import RealmSwift

class Repository {
    private let realm = try! Realm()
    
    func fetchFriends() -> [Friends] {
        print(realm.configuration.fileURL ?? "")
        return Array(realm.objects(Friends.self))
        
        
    }
    func fetchPhotos(ownerId:Int) -> [Photos] {
        return Array(realm.objects(Photos.self).filter("ownerId == %@", ownerId))
        
    }
}
