//
//  AvatarView.swift
//  VKlient
//
//  Created by Никита Дмитриев on 27.10.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
 
    var shadowRadius:CGFloat = 0 {
        didSet{
            updateShadow()
        }
    }
    
    var shadowColor:UIColor = .black {
        didSet{
            updateShadow()
        }
    }
    
    //прозрачность тени
    var shadowOpacity:Float = 1 {
        didSet{
            updateShadow()
        }
    }
    
    var image:UIImage? {
        didSet{
            imageView.image = image
            //перерисуем вью
            setNeedsDisplay()
        }
    }
    
    //Mark - описываем сабвью для картинки и тени
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        //обрезать содержимое сабвью по размерам внешней вью
        imageView.clipsToBounds = true
        return  imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false // чтобы тень не обрезалась
        view.backgroundColor = .white
        return view
    }()
    
    //Init переопределяем
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    
    private func setup() {
        
        //добавляем сабвью
        addSubview(shadowView)
        addSubview(imageView)
        
        //располагаем вью через констрейны
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //массив констрейнов
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
    }
    
    private func updateShadow() {
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOpacity = shadowOpacity
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width/2
        shadowView.layer.cornerRadius = shadowView.frame.width/2
    }
    
    @objc private func viewTapped(sender: UIGestureRecognizer) {
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.transform = .identity
        },
            completion: nil
        )
    }
}
