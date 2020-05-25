//
//  ToDoListViewController.swift
//  todoey
//
//  Created by Hamza Iqbal on 08/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class ToDoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category?{
        didSet{
            loaditems()
        }
    }
    //       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print(dataFilePath)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    //                realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("err saving done \(error)")
            }
        }
        tableView.reloadData()
        
        //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "no items added"
        }
        
        
        
        return cell
    }
    
    
    
    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var tf = UITextField()
        let alert = UIAlertController(title: "Add todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCate = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = tf.text!
                        newItem.date = Date()
                        currentCate.items.append(newItem)
                    }
                    
                }catch{
                    print("err saving items, \(error)")
                }
                self.tableView.reloadData()
                
            }
            
            
        }
        
        //            newItem.parentCategory = self.selectedCategory
        //            self.itemArray.append(newItem)
        
        //            self.saveItems()
        
        
        
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Create new Item"
            tf = alertTF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //    func saveItems(){
    //
    //        do{
    //            try context.save()
    //
    //        }
    //        catch{
    //            print("err saving the context\(error)")
    //        }
    //        self.tableView.reloadData()
    //    }
    
    //    func loaditems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
    //
    //        let Categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //
    //        if let additionalPredicate = predicate{
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate, additionalPredicate])
    //        }else{
    //            request.predicate = Categorypredicate
    //        }
    //        do{
    //          itemArray = try context.fetch(request)
    //            tableView.reloadData()
    //        }catch{
    //            print("err fetching the context\(error)")
    //
    //        }
    //    }
    
    func loaditems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
        
    }
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loaditems(with: request, predicate: predicate)


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
