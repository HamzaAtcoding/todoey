//
//  ToDoListViewController.swift
//  todoey
//
//  Created by Hamza Iqbal on 08/03/2020.
//  Copyright © 2020 Hamza Iqbal. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaditems()
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
            
            
            let newItem = Item()
            newItem.title = tf.text!
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("err in encoding, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loaditems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self , from: data)
            }catch{
                print("err decoding \(error)")
            }
        }
    }

}
