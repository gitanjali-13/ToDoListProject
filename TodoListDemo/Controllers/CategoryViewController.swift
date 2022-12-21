//
//  CategoryViewController.swift
//  TodoListDemo
//
//  Created by Admin on 20/12/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
         
    var category = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    // tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    
    // tableview delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        return cell
    }
    // tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            destinationVC.selectedCategory = category[indexPath.row]    
        }
    }
    // data manipulation methods
    
    func saveCategory() {
        do {
            try context.save()
        }catch {
            print("Erro saving categories. \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories() {
        let request : NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            category = try context.fetch(request)
        }catch {
            print("Error loading categoris \(error)")
        }
        tableView.reloadData()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){(action) in
            let newCategory = Categories(context: self.context)
            newCategory.name = textField.text!
            
            self.category.self.append(newCategory)
            self.saveCategory()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Add new category"
            
        }
        present(alert, animated: true, completion: nil)
        
        }
    }
    
