//
//  ViewController.swift
//  TodoListDemo
//
//  Created by Admin on 12/12/22.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

//add button to perorm action and give alert for add
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() 
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()        //set obj newItem=class objectItem()instance
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in    //local variable scope is only within this method , limited scope
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
//tableview datasource methods
//method to view content in number of rows in seperate sections
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
        
//tableview delegate methods
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //update data or select item from list
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
//                        realm.delete(item)      //delete selected item on one click
//                        loadItems()
                       item.done = !item.done      //update to checkmark on selected item
                    }
                } catch {
                        print("Error saving done status \(error)")
                    }
                }
                tableView.reloadData()
            
//            context.delete(itemarray[indexPath.row])
//            itemarray.remove(at: indexPath.row)
//            todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
            
//            saveItems()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func loadItems() {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
            tableView.reloadData()
        }
        
    }
// search bar methods
    
    extension ToDoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
//            todoItems = todoItems?.filter("title CONTAINS[cd] %@" , searchBar.text!)
//                .sorted(byKeyPath: "title", ascending: true)
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!) .sorted(byKeyPath: "dateCreated", ascending: true)
            //searchBar.resignFirstResponder()
            
            tableView.reloadData()
    
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
            print(searchText)  //printing text
            if searchBar.text?.isEmpty == true{
                
                loadItems()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
    
    

