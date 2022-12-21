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
    
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    //method to view content in number of rows in seperate sections
    //tableview datasource methods
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  //create local var in this scope to entire addButton scope
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default ){
            (action) in
            
            let newItem = Item(context: self.context )  //set obj newItem=class objectItem()instance
            
            newItem.title = textField.text!
            
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
//                context.delete(itemarray[indexPath.row])
//                itemarray.remove(at: indexPath.row)             //delete item from list
        
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
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
            
        }else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemarray = try context.fetch(request)
        }catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()                  //
    }
    
}
// search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //searchBar.resignFirstResponder()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText)  //printing text
        if searchBar.text?.isEmpty == true{

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        } else{
            let request : NSFetchRequest<Item> = Item.fetchRequest()

            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            loadItems(with: request , predicate: predicate)
        }
    }
}

