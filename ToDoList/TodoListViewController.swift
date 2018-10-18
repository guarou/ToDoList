//
//  ViewController.swift
//  ToDoList
//
//  Created by Study on 2018/10/16.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray = [TodoItem]()
    let defaults = UserDefaults.standard
    var textField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem1 = TodoItem()
        newItem1.title = "eat breakfast"
        itemArray.append(newItem1)
        
        if let items = defaults.array(forKey: "toDoListArray") as? [TodoItem]{
            itemArray = items
        }
    }

    //Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    //Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Add items to list
    @IBAction func addToList(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add item", message: "Do you want to add item to the list?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            self.textField = textField
            self.textField?.placeholder = "Add an item..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let itemToAdd = TodoItem()
            
            itemToAdd.title = (self.textField?.text!)!
            self.itemArray.append(itemToAdd)
                
            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            self.tableView.reloadData()
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        //alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    

}

