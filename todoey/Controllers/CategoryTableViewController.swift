//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Hamza Iqbal on 10/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        
    //    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else{fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    // MARK: - Table view data manipulation
    
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("error saving category\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        //        let request: NSFetchRequest<Category> = Category.fetchRequest()
        //        
        //        do{
        //        categories = try context.fetch(request)
        //        }
        //        catch{
        //            print("error loading category\(error)")
        //
        //        }
        tableView.reloadData()
        
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        if let categoryToBeDel = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryToBeDel)
                }
            }
            catch{
                print("err del category\(error)")
            }
            //            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
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
            dest.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
