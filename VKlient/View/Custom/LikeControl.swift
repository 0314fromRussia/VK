//
//  LikeControl.swift
//  VKlient
//
//  Created by Никита Дмитриев on 27.10.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit


class LikeControl: UIControl {
    
    
    var isLiked: Bool = false {
        didSet {
            updateLike()
        }
    }
    
    
    var likesCount: Int = 0 {
        didSet {
            countLabel.text = "\(likesCount)"
        }
    }
    
    
    var color: UIColor = .red {
        didSet {
            likeButton.tintColor = color
            countLabel.textColor = color
        }
    }
    
    // описываем сабвью для кнопки и счетчика
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = color
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return  button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        label.text = "0"
        return label
    }()
    
    // стек, где хранятся кнопка и счетчик
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4           // расстояние между элементами
        stackView.alignment = .center
        return stackView
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
    
    
    private func setup() {          // верстка вью
        
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
                                        stackView.topAnchor.constraint(equalTo: topAnchor),
                                        stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                        stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                        stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
        stackView.addArrangedSubview(likeButton)        //добавляем кнопку в стек
        stackView.addArrangedSubview(countLabel)        // добавляем счетчик
    }
    
    //Action
    @objc private func likeButtonTapped (_ sender: UIButton) {
        // toggle меняет булево значение на противоположное
        isLiked.toggle()
        
        sendActions(for: .valueChanged) //посылаем событие, когда кнопка нажата
        
        // анимация для лайка
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.likeButton.frame.origin.y -= 100 })
    }
    
    private func updateLike() {
        let imageName = isLiked ? "heart.fill" : "heart"        // меняем картинку лайка
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)   //устанавливаем картинку на кнопку
        likesCount = isLiked ? likesCount + 1 : likesCount - 1              // добавляем и уменьшаем кол-во лайков
    }
    
}
