//
//  FriendsCollectionViewController.swift
//  VKlient
//
//  Created by Никита Дмитриев on 14.10.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos: [Photos] = []
    var friendId: Int = 0
    lazy var service = VkAPIService()
    lazy var repository = Repository()
    var userName: String = ""
    
    //MARK: - UICollectionViewDataSource
    
    private enum Constant {
        static let padding: CGFloat = 5
    }
   
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromCach()
        
      
            self.service.getPhotos(ownerId: self.friendId) { [weak self]  in
                self?.collectionView.reloadData()
            }
    
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let controller = segue.destination as? GalleryViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first
            else { return }
        controller.title = title
        controller.photos = photos
        controller.currentIndex = indexPath.row
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FriendsCollectionCell
        
        let photo = photos[indexPath.row]
        
       cell.iconImageLabel.downloadImage(urlPath: photo.imageUrl)
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - Constant.padding) / 2
        return CGSize(width: width, height: width)
    }

    
    func collectionView(_ collectionView:UICollectionView, layout: UICollectionViewLayout, insetForSectionAt: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView:UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return Constant.padding
    }
   
    func collectionView(_ collectionView:UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return Constant.padding
    }

    
    // MARK:- Realm
    private func loadFromCach() {
        
        photos = repository.fetchPhotos(ownerId: friendId)
    
        collectionView.reloadData()
    }
}
