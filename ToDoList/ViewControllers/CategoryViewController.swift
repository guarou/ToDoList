//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Study on 2018/10/23.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryList()
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "Do you want to add category to the list?", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a category..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let categoryToAdd = Category()
            categoryToAdd.name = textField.text!
            
            self.saveCategoryList(category: categoryToAdd)
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        //alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource and Delegates Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category added"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationViewController.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func saveCategoryList(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error:\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategoryList(){
       
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
