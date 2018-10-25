//
//  ViewController.swift
//  ToDoList
//
//  Created by Study on 2018/10/16.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryViewControllerDelegate: class{
    func loadingTodoItems()->[TodoItem]
}

class TodoListViewController: UITableViewController{
    
    var itemArray = [TodoItem]()
    
    var selectedCategory: Category?{
        didSet{
            loadTodoItems()
        }
    }
    
    var textField: UITextField?
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
            
            let itemToAdd = TodoItem(context: self.context)
            
            itemToAdd.title = (self.textField?.text!)!
            itemToAdd.done = false
            itemToAdd.parentCategory = self.selectedCategory
            
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
        //let encoder = PropertyListEncoder()
        
        do{
            //let data = try encoder.encode(itemArray)
            //try data.write(to:dataFilePath!)
            try context.save()
        }catch{
            print("Error:\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadTodoItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }

//        do{
//            if let data = try? Data(contentsOf: dataFilePath!){
//                let decoder = PropertyListDecoder()
//                itemArray = try decoder.decode([TodoItem].self, from: data)
//            }
//        }catch{
//            print("Error:\(error)")
//        }
        
        //let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error:\(error)")
        }
        
        tableView.reloadData()
    }

}

//MARK - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTodoItems(with: request, predicate: predicate)
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error:\(error)")
//        }
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

