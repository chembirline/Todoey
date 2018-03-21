//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 14.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit

import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

   
   
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
       loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.rowHeight = 80.0
         tableView.separatorStyle = .none
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
         title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else { fatalError()}
           
        updateNavBar(withHexCode: colourHex)
            
        }
    override func viewWillDisappear(_ animated: Bool) {
      
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    //MARK: - nav bar setup methods
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")}
        
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
        
    }
    //MARK: - Tble view datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
          
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
            
                cell.backgroundColor = colour
                
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
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
    override func updateModel(at indexpath: IndexPath) {
        if let item = self.toDoItems?[indexpath.row] {
            do{
                try self.realm.write {
                    
                    
                    self.realm.delete(item)
                    
                }
            } catch {
                print("error deleting \(error)")
            }
        }
    
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


