//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 19.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        loadCategories()
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoryArray.count
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            let category = categoryArray[indexPath.row]
            
            cell.textLabel?.text = category.name
        
            return cell
            
        }

    
    
    

    

    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new  category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add", style: .default) { (action ) in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
           
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
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
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
    
    
        //MARK: - Data manipulation methods
    
    func saveCategories() {
        
        do {
            
            try context.save()
        }
        catch{
            print("error saving context \(error)")
            
        }
        tableView.reloadData()
        
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
            
        }
        
        catch { print("error loading categories \(error)")
            
        }
        
    }
    
  
    
   
    

}
