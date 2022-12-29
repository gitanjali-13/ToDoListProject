//
//  CategoryViewController.swift
//  TodoListDemo
//
//  Created by Admin on 20/12/22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
         
    //var categories: Results <Categories>!    //force unwrapping data
    var categories: Results<Categories>?        //optional
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{fatalError("navigation controller does not exists")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    // tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour ) else {
                fatalError()
            }
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
       
        return cell
    }
    
    // tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow  {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // data manipulation methods
    //add new items and save them to realm
    func save(categories: Categories) {
        do {
            try realm.write({
                realm.add(categories)
            })
        }catch {
            print("Erro saving categories. \(error)")
        }
        tableView.reloadData()
    }
    //read the added item manage to loaded objects.
    func loadCategories() {
        
        //let categories = realm.objects(Categories.self)
        
        categories = realm.objects(Categories.self)
    
        tableView.reloadData()
        }
    //mark : delete data from source
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write ({
                    self.realm.delete(categoryForDeletion)
                })
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){(action) in
            let newCategory = Categories()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
//            self.categories.self.append(newCategory)
            self.save(categories: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Add new category"
            
        }
        present(alert, animated: true, completion: nil)
        
        }
    }


