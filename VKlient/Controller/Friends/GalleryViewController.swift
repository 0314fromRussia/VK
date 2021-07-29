//
//  GalleryViewController.swift
//  VKlient
//
//  Created by Никита Дмитриев on 11.11.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    enum Direction {
        case left, right
        
        init(x: CGFloat) {
            self = x > 0 ? .right : .left
        }
    }
    
    //передаем весь массив стрингов фото
    var photos: [Photos] = [] {
        didSet {
         self.images = photos.compactMap {_ in UIImage(named: "1")}
        }
    }
    var images: [UIImage] = []
    var currentIndex = 0 //нулевой индекс
   

    @IBOutlet weak var imageView: UIImageView!
    
    // следующая вью после свайпа
    lazy var nextImageView = UIImageView()
    
    private var animator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dowmloadImages()
        
        imageView.contentMode = .scaleAspectFit
        nextImageView.contentMode = .scaleAspectFit
        
        imageView.image = images[currentIndex]  // загружаем текущую картинку
        
        //добавляем жест
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        view.addGestureRecognizer(pan)
        
        
    }
    
    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        guard let panView = recognizer.view else { return }
        
        let translation = recognizer.translation(in: panView)   //изменение жеста
        let direction = Direction(x: translation.x)
        
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.imageView.alpha = 0
            })
            
            // если мы можем показать следующий слайд
            if canSlide(direction) {
                let nextIndex = direction == .left ? currentIndex + 1 : currentIndex - 1
                nextImageView.image = images[nextIndex]
                view.addSubview(nextImageView)
                
                let offsetX = direction == .left ? view.bounds.width : -view.bounds.width
                nextImageView.frame = view.bounds.offsetBy(dx: offsetX, dy: 0)
                
                animator.addAnimations({
                    self.nextImageView.center = self.imageView.center
                }, delayFactor: 0.2)
            }
            
            // откатываем параметры для новой картинки, удаляем старую картинку из супервью, добавляем новую
            animator.addCompletion{(position) in
                guard position == .end else { return }
                
                self.currentIndex = direction == .left ? self.currentIndex + 1 : self.currentIndex - 1
                self.imageView.alpha = 1
                self.imageView.transform = .identity
                self.imageView.image = self.images[self.currentIndex]
                self.nextImageView.removeFromSuperview()
            }
            animator.pauseAnimation()
            
        case . changed:
            let relativeTranslation = abs(translation.x) / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            animator.fractionComplete = progress
            
        case .ended:
            
            
            if canSlide(direction), animator.fractionComplete > 0.6 { // проверяем прошла ли анимация 0.6
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {    // если анимация не прошла 0.6 то возвращаем исходную картинку
                animator.stopAnimation(true)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.transform = .identity
                    self.imageView.alpha = 1
                    let offsetX = direction == .left ? self.view.bounds.width : -self.view.bounds.width
                    self.nextImageView.frame = self.view.bounds.offsetBy(dx: offsetX, dy: 0)
                }
                
            }
        
        default:
            break
        }
    }

    //проверяем currentIndex в зависимости от направления движения свайпа
    private func canSlide(_ direction: Direction) -> Bool {
        if direction == .left {
            return currentIndex < images.count - 1
        } else {
            return currentIndex > 0
        }
    }
    
    private func dowmloadImages() {
        
        for (index, photo) in photos.enumerated() {
            guard let url = URL(string: photo.imageUrl) else {continue}
            
            let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, response, error) in
                    guard let data = data, let image = UIImage(data: data) else {
                        return
                    }
                    self.images[index] = image
                }
            task.resume()
        }
    }
}
