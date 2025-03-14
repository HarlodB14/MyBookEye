//
//  BookViewModel.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//
import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []  // List of books to be shown
    @Published var query: String = ""  // Query for the search

    private var bookService = BookService()

    // Function to fetch books based on the query
    func fetchBooks(query: String) async {
        do {
            self.books = try await bookService.fetchBooks(query: query)
        } catch {
            print("Failed to fetch books: \(error)")
        }
    }
}


