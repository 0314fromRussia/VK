//
//  LetterPicker.swift
//  VKlient
//
//  Created by Никита Дмитриев on 01.11.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit

protocol LetterPickerDelegate: class {
    func letterPicked(_ letter: String)
}

class LetterPicker: UIView {

    weak var delegate: LetterPickerDelegate?
    
    var letters: [String] = "abcdefghijklmnopqrstuvwxyz".map {String($0)} {
        didSet {
            reload()
        }
    }

    private var buttons: [UIButton] = []
    private var lastPressedButton: UIButton?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0          // расстояние между элементами
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

    // верстка вью
    private func setup() {
        
        backgroundColor = .clear
        
        setupButtons()
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: topAnchor),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        addGestureRecognizer(pan)
        
    }
    
    private func setupButtons() {
        for letter in letters {
            let button = UIButton(type: .system)
            button.setTitle(letter.uppercased(), for: .normal)      // с большой буквы тайтл
            button.addTarget(self, action: #selector(letterTapped), for: .touchDown)     // вешаем обработчик событий на кнопку
            buttons.append(button)
            stackView.addArrangedSubview(button)            // добавляем кнопку в стек
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true     // высота для кнопки
            
        }
    }
    

    @objc private func letterTapped(_ sender:UIButton) {
        
        guard lastPressedButton != sender else {return}         // чтобы не вызывать метод много раз, когда мы перемещаемся в рамках одной кнопки
        lastPressedButton =  sender
        let letter = sender.title(for: .normal) ?? ""
        delegate?.letterPicked(letter)
    }
    
    @objc private func panAction(_ recognizer:UIPanGestureRecognizer) {
        let anchorPoint = recognizer.location(in: self)         //создаем точку, чтобы следить за пальцем на контроле
        let buttonHeight = bounds.height / CGFloat(buttons.count)   // высота контрола
        let buttonIndex = Int(anchorPoint.y / buttonHeight)     //высчитываем координату
        
        guard buttonIndex >= 0 && buttonIndex < buttons.count else { return }
        
        unhighlightButtons()
        let button = buttons[buttonIndex]       // получаем текущую кнопку
        unhighlightButtons()                    // убрали подсветку со всех кнопок
        button.isHighlighted = true             // подсветили текущую кнопку
        letterTapped(button)                    // нажали кнопку
    }
    
    //убрать подсветку со всех кнопок (поменять состояние кнопки на нормал)
    private func unhighlightButtons() {
        buttons.forEach {$0.isHighlighted = false}
    }
    
    private func reload() {
        stackView.arrangedSubviews.forEach {$0.removeFromSuperview()}       // отчищаем стек
        buttons = []
        lastPressedButton = nil
        setupButtons()
    }
}
