//
//  ViewController.swift
//  ToDoList
//
//  Created by Study on 2018/10/16.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import UIKit
import RealmSwift

protocol CategoryViewControllerDelegate: class{
    func loadingTodoItems()->[TodoItem]
}

class TodoListViewController: UITableViewController{
    
    var todoItems: Results<TodoItem>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadTodoItems()
        }
    }
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(dataFilePath!)
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        if let items = defaults.array(forKey: "toDoListArray") as? [TodoItem]{
//            itemArray = items
//        }
    }

    //Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error:\(error)")
            }
        }
        
        tableView.reloadData()
        
        //todoItems[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //saveTodoItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Add items to list
    @IBAction func addToList(_ sender: UIBarButtonItem) {
        
         var textField = UITextField()
        
        let alert = UIAlertController(title: "Add item", message: "Do you want to add item to the list?", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add an item..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let itemToAdd = TodoItem()
                        itemToAdd.title = textField.text!
                        itemToAdd.dateCreated = Date()
                        currentCategory.items.append(itemToAdd)
                    }
                }catch{
                    print("Error:\(error)")
                }
                //self.saveTodoItems(todoItems: itemToAdd)
            }
            
            self.tableView.reloadData()
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        //alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadTodoItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

//MARK - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadTodoItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder
            }
        }
    }
}

