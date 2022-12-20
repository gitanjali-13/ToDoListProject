//
//  ViewController.swift
//  TodoListDemo
//
//  Created by Admin on 12/12/22.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemarray = [Item]()        // creating new array of class item objects
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in:
                .userDomainMask))
        loadItems()
        
        
        
    }
    //method to view content in number of rows in seperate sections
    //tableview datasource methods
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  //create local var in this scope to entire addButton scope
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default ){
            (action) in
            
            let newItem = Item(context: self.context )  // set newItem =  class object Item()
            
            newItem.title = textField.text!
            
            newItem.done = false
            self.itemarray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in    //local variable scope is only within this method , limited scope
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemarray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemarray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none  // ternory op
        return cell
    }
    //tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemarray[indexPath.row].setValue("Completed", forKey: "title")   //update value
        
        //        context.delete(itemarray[indexPath.row])
        //        itemarray.remove(at: indexPath.row)
        
        itemarray[indexPath.row].done = !itemarray[indexPath.row].done
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func saveItems() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context , \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems(with request : NSFetchRequest <Item> = Item.fetchRequest()) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemarray = try context.fetch(request)
        }catch {
            print("Error fetching data \(error)")
        }
    }
    
}
// search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "tital CONTAINS %@", searchBar.text!)
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

