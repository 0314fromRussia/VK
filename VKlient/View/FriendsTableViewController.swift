//
//  FriendsTableViewController.swift
//  VKlient
//
//  Created by Никита Дмитриев on 14.10.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LetterPickerDelegate, UISearchBarDelegate {
    
    
    lazy var service = VkAPIService()
    lazy var repository = Repository()
    
    private var filteredFriends = [Friends]()
    
    
    var notificationToken: NotificationToken?
    // Data source
    
    var sections: [String] = [] // первые уникальные буквы фамилии
    var allItems: [Friends] = []
    var filteredItems: [Friends] = []
    var cachedSectionItems: [String:[Friends]] = [:]     // для кеширования getItems
    
    // метод, который возвращает айтемс для секции (кол-во друзей в секции)
    func getItems(for section: Int) -> [Friends] {
        let sectionLetter = sections[section] // первая буква по индексу
        
        if let sectionItems = cachedSectionItems[sectionLetter] {
            return sectionItems         //  если что-то было в кеше, то мы это вернем
        }
        let sectionItems = filteredItems.filter {
            $0.lastName.uppercased().prefix(1) == sectionLetter     // выбираем из массива тех, чья первая буква фамилии совпадает с буквой секции
            
        }
        cachedSectionItems[sectionLetter] =  sectionItems
        return sectionItems
    }
    
    // метод, который возвращает конкретного пользователя для индекспути
    
    func getItem(for indexPath: IndexPath) -> Friends {
        return getItems(for: indexPath.section)[indexPath.row]
    }
    
    func filterItems(text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredItems = allItems
            return
        }
        
        filteredItems = allItems.filter {
            $0.fullName.lowercased().contains(text.lowercased())
        }
    }
    
    // Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterPicker: LetterPicker!
    @IBOutlet weak var searchView: SearchView!
    
    
    func filterContentForSearchName(_ searchText: String) {

        filteredFriends = repository.fetchFriends().filter({ (friend: Friends) -> Bool in
            guard friend.firstName.lowercased().contains(searchText.lowercased()) else {
                return false
            }
            return true
        })
        tableView.reloadData()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        filterContentForSearchName(searchView.textField.text ?? "")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        loadFromCach()
        reloadDataSource()
        setupViews()
        
        self.service.getFriends { [weak self] in
            self?.loadFromCach()
            
        }
        
        
        let realm = try! Realm()
        let friends = realm.objects(Friends.self)
        notificationToken = friends.observe {
            (changes) in
            
            switch changes {
            case .initial(let results):
                print(results)
                self.loadFromCach()
            case let .update(results, deletions, insertions, modifications):
                self.loadFromCach()
                print(results)
                print(deletions)
                print(insertions)
                print(modifications)
            case .error(let error):
                print(error)
            }
        }
    }
    
    
    // Setup
    
    private func reloadDataSource() {
        
        filterItems(text: searchView.text)
        
        let allLetters = filteredItems.map {String($0.lastName.uppercased().prefix(1))}
        sections = Array(Set(allLetters)).sorted()               // set отбросит все повторяющиеся буквы
        
        cachedSectionItems = [:]
    }
    
    private func setupViews() {
        letterPicker.delegate = self        //текущий класс будет являть делегатом
        letterPicker.letters = sections
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        guard let controller = segue.destination as? FriendsCollectionViewController else {return}
        guard let selectedCell = sender as? FriendsTableViewCell else {return}
        guard let indexPath = tableView.indexPath(for: selectedCell) else {return}
        
        let selectedUser = getItem(for: indexPath).id
        let userName = getItem(for: indexPath).fullName
        controller.friendId = selectedUser
        controller.userName = userName
        
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return getItems(for: section).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsTableViewCell
        
        
        let item = getItem(for: indexPath)
        cell.nameLabel.text = item.fullName
        cell.avatarView.imageView.downloadImage(urlPath: item.photo)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func letterPicked(_ letter: String) {
        
        guard let sectionIndex = sections.firstIndex(where: {$0 == letter}) else {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)      // перемещаем табличку под букву
    }
    
    
    
    
    // MARK:- Realm
    
    private func loadFromCach() {
        
        allItems = repository.fetchFriends()
        reloadDataSource()
        tableView.reloadData()
    }
}

