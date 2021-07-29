//
//  VkAPIService.swift
//  VKlient
//
//  Created by Никита Дмитриев on 25.11.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import Foundation
import RealmSwift

final class VkAPIService {
    
    let session = Session.shared
    
    enum ApiMethod {
        case friends
        case photo(id:Int)
        
        
        var path: String {
            switch self {
            case .friends:
                return "/method/friends.get"
            case .photo:
                return "/method/photos.getAll"
                
            }
        }
        
        var parameters: [String: String] {
            switch self {
            case .friends:
                return ["fields": "photo_100"]
            case .photo(let id):
                return ["owner_id": String(id)]
                
            }
        }
        
    }
    
    
    
    //@escaping помечается, чтобы комплишен блок жил дольше метода и вызвался после
    private func request(_ method: ApiMethod, completion: @escaping (Data?) -> Void) {
        
        DispatchQueue.global(qos:.utility).async {
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.vk.com"
            components.path = method.path
            let defaultQueryItems = [
                URLQueryItem(name: "access_token", value: self.session.token),
                URLQueryItem(name: "v", value: "5.126")
            ]
            let methodQueryItems = method.parameters.map {
                URLQueryItem(name: $0, value: $1)
            }
            components.queryItems = defaultQueryItems + methodQueryItems
            
            
            guard let url = components.url else {
                completion(nil)
                return
            }
            print(url)
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                completion(data)
            }
            task.resume()
            print(url)
        }
    }
    
    
    func getFriends(completion: @escaping () -> Void) {
        request(.friends) { [weak self] (data) in
            guard let data = data else {return}
            
            do {
                let response = try JSONDecoder().decode(VKResponse<Friends>.self, from: data)
                self?.saveToRealm(response.items)
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func getPhotos(ownerId: Int,completion: @escaping () -> Void) {
        request(.photo(id: ownerId)) { [weak self] (data) in
            guard let data = data else {return}
            
            do {
                let response = try JSONDecoder().decode(VKResponse<Photos>.self, from: data)
                self?.saveToRealm(response.items)
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    
    
    
    private func saveToRealm<T: Object>(_ objects:[T]) {
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch {
            print(error)
        }
        
        
    }
    
}
