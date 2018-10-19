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
    var textField: UITextField?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(dataFilePath!)
        
        loadTodoItems()
        
//        if let items = defaults.array(forKey: "toDoListArray") as? [TodoItem]{
//            itemArray = items
//        }
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
        saveTodoItems()
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
                
            //self.defaults.set(self.itemArray, forKey: "toDoListArray")
            
            self.saveTodoItems()
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        //alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTodoItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("Error:\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadTodoItems(){
        
        do{
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([TodoItem].self, from: data)
            }
        }catch{
            print("Error:\(error)")
        }
    }

}

