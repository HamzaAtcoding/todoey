//
//  ToDoListViewController.swift
//  todoey
//
//  Created by Hamza Iqbal on 08/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category?{
        didSet{
            loaditems()
        }
    }
       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(dataFilePath)
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
         
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
    }
    
    
    
    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var tf = UITextField()
        let alert = UIAlertController(title: "Add todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = tf.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new Item"
            tf = alertTF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
        do{
            try context.save()
           
        }
        catch{
            print("err saving the context\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loaditems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let Categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate, additionalPredicate])
        }else{
            request.predicate = Categorypredicate
        }
        do{
          itemArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("err fetching the context\(error)")

        }
    }
    
    

}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loaditems(with: request, predicate: predicate)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loaditems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()

            }

            
        }
    }
}
