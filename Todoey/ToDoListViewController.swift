//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 14.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
        
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
        
        //yukaridaki kodun aynisi
        //+++++++++++------+++++++
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
        
    }
    //MARK - TAbleView Delegate Methods
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    saveItems()
   
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
            self.saveItems()
        }
        
       alert.addTextField { (alertTextField) in
       
        alertTextField.placeholder = "Create new Item"
        
        textField = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
           let decoder = PropertyListDecoder()
            do {itemArray = try decoder.decode([Item].self, from: data)
        }
         catch{
            print("error decoding item array \(error)")
        }
    }
}
    
    
}



