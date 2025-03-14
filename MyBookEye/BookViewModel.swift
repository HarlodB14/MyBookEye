//
//  BookViewModel.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//
import Foundation

import SwiftUI

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []  // List of books to be shown
    @Published var query: String = ""  // Query for the search
    @Published var isLoading: Bool = false // Loading state
    @Published var errorMessage: String? = nil // Error message
    @Published var currentPage: Int = 1 // Current page number
    @Published var totalPages: Int = 1 // Total pages based on search results
    @Published var itemsPerPage: Int = 10 // Number of items per page

    private var bookService = BookService()

    // Function to fetch books based on the query and current page
    func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch books with pagination (using current page and items per page)
            let (fetchedBooks, totalPages) = try await bookService.fetchBooks(query: query, page: currentPage, itemsPerPage: itemsPerPage)
            
            // Set the fetched books and total pages
            self.books = fetchedBooks
            self.totalPages = totalPages
        } catch {
            self.errorMessage = "Failed to fetch books. Please try again."
        }
        
        isLoading = false
    }

    // Function to load the next page of books
    func loadNextPage() {
        if currentPage < totalPages {
            currentPage += 1
            Task {
                await fetchBooks()
            }
        }
    }

    // Function to load the previous page of books
    func loadPreviousPage() {
        if currentPage > 1 {
            currentPage -= 1
            Task {
                await fetchBooks()
            }
        }
    }
}



