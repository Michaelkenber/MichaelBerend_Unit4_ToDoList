//
//  ToDo.swift
//  ToDoList
//
//  Created by Michael Berend on 28/02/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import Foundation

/// create a struct for the not
struct ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    
    // format date with short notation
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // load the coded to do's, if they exist
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    // create file path for directory
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    
// encode todo's and save to dirrectory
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    // load pre-created sample to do's to app
    static func loadSampleToDos() -> [ToDo] {
    let todo1 = ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1")
    let todo2 = ToDo(title: "ToDo two", isComplete: false, dueDate: Date(), notes: "Notes 2")
    let todo3 = ToDo(title: "ToDo three", isComplete: false, dueDate: Date(), notes: "Notes 3")
    
    return [todo1, todo2, todo3]
    }
}
