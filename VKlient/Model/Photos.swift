//
//  Photos.swift
//  VKlient
//
//  Created by Никита Дмитриев on 06.12.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import Foundation
import RealmSwift


final class Photos: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageUrl: String = ""
    
    static override func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sizes
        case url
    }
    convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.ownerId = try container.decode(Int.self, forKey: .ownerId)
        
        var sizesArrayContainer = try container.nestedUnkeyedContainer(forKey: .sizes)      // nestedUnkeyedContainer - берез берет вложенный массив в json
        let firstContainer = try sizesArrayContainer.nestedContainer(keyedBy: CodingKeys.self)  //берет первый элемент массива
        self.imageUrl = try firstContainer.decode(String.self, forKey: .url)
    }
}



