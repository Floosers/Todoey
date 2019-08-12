//
//  ViewController.swift
//  Todoey
//
//  Created by Zees on 2019-08-05.
//  Copyright © 2019 floosers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var defaults = UserDefaults.standard
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Get Steve"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Get Robin"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Get Erica"
        itemArray.append(newItem3)
        let newItem4 = Item()
        newItem4.title = "Infiltrate Russian base"
        itemArray.append(newItem4)
        

        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
        
        // Do any additional setup after loading the view.
    }
    ////////////////////////////////////////////
    //MARK - Table View Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        cell.textLabel?.text = item.title //the cell's text is equal to the items in the itemArray at the row of the index path
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    ////////////////////////////////////////////
    //MARK - Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    ////////////////////////////////////////////
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (alert) in
            //what tp do when the button is clicked
            let newItem = Item()
            newItem.title = textField.text!
        self.itemArray.append(newItem)
        self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        self.tableView.reloadData()
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        }
            }
    
    


