//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 14.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Hadi"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Hadi2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Hadi3"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
        tableView.backgroundColor = UIColor.blue
        
    }
//MARK - Tble view datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.backgroundColor = UIColor.cyan
        
        
        cell.accessoryType = item.done ? .checkmark : .none
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
        
    }
    //MARK - TAbleView Delegate Methods
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new toDoey item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "add item", style: .default) { (action ) in
           
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
           
        }
        
       alert.addTextField { (alertTextField) in
       
        alertTextField.placeholder = "Create new Item"
        
        textField = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}




