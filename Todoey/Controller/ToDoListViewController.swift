//
//  ViewController.swift
//  Todoey
//
//  Created by Zees on 2019-08-05.
//  Copyright © 2019 floosers. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        // context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
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
            //what to do when the button is clicked
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.title = textField.text!
        self.itemArray.append(newItem)
        self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        }
    //MARK - Model Manipulation Methods
    func saveItems() {

        do {
            try context.save()
        }
        catch {
         print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }


    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
         itemArray = try context.fetch(request)
    }
        catch {
            print("Error fetching data from context \(error)")
    }
        self.tableView.reloadData()
}
    



}

extension TodoListViewController: UISearchBarDelegate {
    //MARK - Search bar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
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
