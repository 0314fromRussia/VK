////
////  GroupsTableViewController.swift
////  VKlient
////
////  Created by Никита Дмитриев on 14.10.2020.
////  Copyright © 2020 Никита Дмитриев. All rights reserved.
////
//
//import UIKit
//
//class GroupsTableViewController: UITableViewController {
//
////    var groups: [Groups] = []
////    lazy var service = VkAPIService()
////
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        
////            self.service.getGroups { [weak self] (groups) in
////                self?.tableView.reloadData()
////            }
////        
////    }
////
////    // MARK: - Table view data source
////
////    override func numberOfSections(in tableView: UITableView) -> Int {
////        // #warning Incomplete implementation, return the number of sections
////        return 1
////    }
////
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        // #warning Incomplete implementation, return the number of rows
////        return groups.count
////    }
////
////    
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupsCell
////
////        let group = groups[indexPath.row]
////        //cell.groupsTitleLabel.text = group
////        cell.groupsTitleLabel.text = String(group.name)
////
////        return cell
////    }
////    
////    // удаляем группу с свайпом
////    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete {
////            groups.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
////        }
////    }
//
////    @IBAction func unwindFromAllGroups(_ sender: UIStoryboardSegue) {
////
////        guard // получаем ссылку на контроллер, с которого осуществляем переход
////            let controller = sender.source as? GroupsSearchTableViewController,
////            //получаем индекс выделенной ячейки
////            let indexPath = controller.tableView.indexPathForSelectedRow
////            else {return}
////        // получаем группу по индексу
////        let group = controller.groups[indexPath.row]
////        //проверяем, что такой группы нет в списке
//////        if groups.contains(group) {
//////            return
//////        }
//////        // добавляем группу
//////        groups.append(group)
////        //обновляем таблицу
////        tableView.reloadData()
////
////    }
//
//
//}
