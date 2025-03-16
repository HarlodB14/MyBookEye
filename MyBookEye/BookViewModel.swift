//
//  BookViewModel.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//
import Foundation

import SwiftUI

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []  //
    @Published var query: String = ""  //
    @Published var isLoading: Bool = false // Loading state
    @Published var errorMessage: String? = nil //
    @Published var currentPage: Int = 1 //
    @Published var totalPages: Int = 1 //
    @Published var itemsPerPage: Int = 10 //

    private var bookService = BookService()


    func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {

            let (fetchedBooks, totalPages) = try await bookService.fetchBooks(query: query, page: currentPage, itemsPerPage: itemsPerPage)
            
            // Set the fetched books and total pages
            self.books = fetchedBooks
            self.totalPages = totalPages
        } catch {
            self.errorMessage = "Failed to fetch books. Please try again."
        }
        
        isLoading = false
    }

    func loadNextPage() {
        if currentPage < totalPages {
            currentPage += 1
            Task {
                await fetchBooks()
            }
        }
    }

    func loadPreviousPage() {
        if currentPage > 1 {
            currentPage -= 1
            Task {
                await fetchBooks()
            }
        }
    }
}



