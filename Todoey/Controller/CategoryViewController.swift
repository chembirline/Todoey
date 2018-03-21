//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 19.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CategoryViewController: SwipeTableViewController{
    
     let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
      loadCategories()
      tableView.rowHeight = 80.0
       
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories?.count ?? 1
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
       
        


        return cell
            
        }

    
    
    

    

    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new  category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add", style: .default) { (action ) in
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
           newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
    }
       //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if  let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    
        //MARK: - Data manipulation methods
    
    func save(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
                }
        }
        catch{
            print("error saving context \(error)")
            
        }
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        
         categories = realm.objects(Category.self)
        
     }
    //MARK: - Delete Section
    
    override func updateModel(at indexpath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexpath.row] {
                            do{
                                try self.realm.write {
            
            
                                    self.realm.delete(categoryForDeletion)
            
                                }
                            } catch {
                                print("error deleting \(error)")
                            }
                        }
        
    }
    }

   
