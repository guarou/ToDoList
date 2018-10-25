//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Study on 2018/10/23.
//  Copyright © 2018 gary xiao. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    var textField: UITextField?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If coredata is implemented, the default initializer is not allowed

        //        let category1 = Category()
//        category1.name = "Sports"
//        categoryArray.append(category1)
//
//        let category2 = Category()
//        category2.name = "Homework"
//        categoryArray.append(category2)
//
//        let category3 = Category()
//        category3.name = "Eat food"
//        categoryArray.append(category3)
        
        loadCategoryList()
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "Do you want to add category to the list?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            self.textField = textField
            self.textField?.placeholder = "Add a category..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let categoryToAdd = Category(context: self.context)
            
            categoryToAdd.name = (self.textField?.text!)!
            
            self.categoryArray.append(categoryToAdd)
            
            self.saveCategoryList()
            
            self.tableView.reloadData()
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        //alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource and Delegates Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    func saveCategoryList(){
        do{
            try context.save()
        }catch{
            print("Error:\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategoryList(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error:\(error)")
        }
        
        tableView.reloadData()
    }
}
