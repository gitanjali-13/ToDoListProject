//
//  ViewController.swift
//  TodoListDemo
//
//  Created by Admin on 12/12/22.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemarray = [Item]()        // creating new array of class item objects
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
    
        print(dataFilePath)
        loadItems()
        
        // Do any additional setup after loading the view.
//        let newItem = Item()
//        newItem.title = "find mike"
//        itemarray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "buy eggos"
//        itemarray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "cloths"
//        itemarray.append(newItem3)
//
//        let newItem4 = Item()
//        newItem4.title = "destroys demorgons"
//        itemarray.append(newItem4)
        //        if let items = defaults.array(forKey: "TODolistItemArray") as? [String] {
        //        itemarray = items
        
        
    }
    //method to view content in number of rows in seperate sections
    //tableview datasource methods
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  //create local var in this scope to entire addButton scope
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default ){
            (action) in
            
            let newItem = Item()   // set newItem =  class object Item()
            
            newItem.title = textField.text!
            
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
        cell.accessoryType = item.done ? .checkmark : .none  // instead of using if-else use ternary operator
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    
        return cell
    }
    //tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemarray[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        itemarray[indexPath.row].done = !itemarray[indexPath.row].done
        saveItems()
        
//        if itemarray[indexPath.row].done == false {
//            itemarray[indexPath.row].done = true
//        } else {
//            itemarray[indexPath.row].done = false
//        }
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemarray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array , \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemarray = try decoder.decode([Item].self, from: data)
            }catch {
                print("error decoding items , \(error)")
            }
        }
        
    }
    
}
