//
//  Session.swift
//  VKlient
//
//  Created by Никита Дмитриев on 22.11.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import Foundation

class Session: CustomStringConvertible {
    
    static let shared = Session()
    private init() {}
    
    var token: String = ""
    var userId: Int = 0
    
    var description: String {
        return "id: \(userId), token: \(token)"
    }
    
}
