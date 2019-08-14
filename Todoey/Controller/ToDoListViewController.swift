//
//  ViewController.swift
//  Todoey
//
//  Created by Zees on 2019-08-05.
//  Copyright © 2019 floosers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadItems()
        
        
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

        saveItems()
        
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
            self.saveItems()
        let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            }
            catch {
              print("Error while encoding item \(error)")
            }
        self.tableView.reloadData()
    }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        }
    //MARK - Model Manupulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error while encoding item \(error)")
        }
        self.tableView.reloadData()
    }

    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
            do {
        itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding item array \(error)")
            }
        }
    }


}
