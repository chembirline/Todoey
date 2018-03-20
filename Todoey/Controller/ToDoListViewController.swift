//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 14.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit

import RealmSwift

class ToDoListViewController: UITableViewController {

   
   
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
       loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
        
        tableView.backgroundColor = UIColor.blue
        
    }
    //MARK: - Tble view datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        if  let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor.cyan
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items yet"
        }
       
        
        
        //yukaridaki kodun aynisi
        //+++++++++++------+++++++
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
        
    }
    //MARK: - TAbleView Delegate Methods
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
            try realm.write {
                
                
//                realm.delete(item)
                
               item.done = !item.done
                
                }
            } catch {
                print("error saving done status \(error)")
            }
        }
         tableView.reloadData()

   
    tableView.deselectRow(at: indexPath, animated: true)
    
    
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new toDoey item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "add item", style: .default) { (action ) in
           
            if let currentCategory = self.selectedCategory {
                
                do
                {
                    try self.realm.write {
                    let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
            }
            } catch {
                print("Error saving new items \(error)")
            }
            }
             
            self.tableView.reloadData()
        }
        
       alert.addTextField { (alertTextField) in
       
        alertTextField.placeholder = "Create new Item"
        
        textField = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


}

    
}

//MARK: - Search Bar Methods


extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}


