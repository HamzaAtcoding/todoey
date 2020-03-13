//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Hamza Iqbal on 10/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    
    // MARK: - Table view data manipulation
    
    func saveCategories(){
        do{
        try context.save()
        }
        catch{
            print("error saving category\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
        categories = try context.fetch(request)
        }
        catch{
            print("error loading category\(error)")

        }
        tableView.reloadData()
        
    }







    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            dest.selectedCategory = categories[indexPath.row]
        }
    }

}
