//
//  UIImageExtension.swift
//  VKlient
//
//  Created by Никита Дмитриев on 08.11.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit
extension UIImage {
    static func loadAvatar (_ title: String) -> UIImage? {
        return UIImage(named: title)
    }
}

extension UIImageView {
    func downloadImage(urlPath: String?) {
        guard let urlPath = urlPath, let url = URL(string: urlPath) else {
            return
        }
        let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
                
            }
            task.resume()
        
    }
}
