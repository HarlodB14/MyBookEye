//
//  BookMarkedBook.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 14/03/2025.
//
import Foundation

struct BookmarkedBook: Identifiable,Codable {
    var id = UUID() //voor UI lists
    var book: Book
    var notes: String
    
    
    init(book: Book, notes: String) {
           self.id = UUID()
           self.book = book
           self.notes = notes
       }
}

