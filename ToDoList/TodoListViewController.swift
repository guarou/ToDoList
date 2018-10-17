//
//  ViewController.swift
//  ToDoList
//
//  Created by Study on 2018/10/16.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray = [String]()
    let defaults = UserDefaults.standard
    var textField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "toDoListArray") as? [String]{
            itemArray = items
        }
    }

    //Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            if let text = self.textField?.text{
                if self.textField?.text != ""{
                    self.itemArray.append(text)
                    self.defaults.set(self.itemArray, forKey: "toDoListArray")
                }
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    

}

