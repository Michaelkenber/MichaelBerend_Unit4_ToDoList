//
//  UITableTableViewController.swift
//  ToDoList
//
//  Created by Michael Berend on 28/02/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    // create an empty array for al the to do's
    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create an edit button
        navigationItem.leftBarButtonItem = editButtonItem
        
        // load to do's, if there are none, load sample to do's
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
        
    }
    
    // create as much rows in the table as there are to do's
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    /// load and deque cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
            fatalError("Could not dequeu")
        }
        cell.delegate = self
        let todo = todos[indexPath.row]
        
        // define cell title
        cell.textLabel?.text = todo.title
        
        // determine if complete button is selected
        cell.isCompleteButton.isSelected = todo.isComplete
        return cell
    }
    
    /// allow the editing of rows
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// let users delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    /// prepare segue to to-do details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
    /// function with a bool that determines if the checkmark is tapped
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    ///  define how to unwind from next segue
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        // add extra to do and save
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoViewController
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        //  save to to-do's
        ToDo.saveToDos(todos)
    }
    
}











