import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var books: [Book] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage: Int = 1
    @State private var totalPages: Int = 1
    @State private var itemsPerPage: Int = 10
    
    let bookService = BookService()

    var body: some View {
        VStack {
            // Search TextField
            TextField("Enter book title", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Search Button
            Button(action: {
                Task {
                    await fetchBooks()
                }
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Loading Indicator
            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                // Error Message
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Display List of Books
                List(books, id: \.key) { book in
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        
                        Text(book.author_name?.joined(separator: ", ") ?? "Unknown Author")
                            .font(.subheadline)
                        
                        if let year = book.firstPublishYear {
                            Text("Published in \(year)")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
            }

            // Pagination Controls
            HStack {
                // Previous Page Button
                Button("Previous") {
                    if currentPage > 1 {
                        currentPage -= 1
                        Task {
                            await fetchBooks()
                        }
                    }
                }
                .disabled(currentPage == 1)
                .padding()

                // Current Page Info
                Text("Page \(currentPage) of \(totalPages)")
                    .padding()

                // Next Page Button
                Button("Next") {
                    if currentPage < totalPages {
                        currentPage += 1
                        Task {
                            await fetchBooks()
                        }
                    }
                }
                .disabled(currentPage == totalPages)
                .padding()
            }
        }
        .padding()
    }

    private func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let (fetchedBooks, totalPages) = try await bookService.fetchBooks(query: query, page: currentPage, itemsPerPage: itemsPerPage)
            books = fetchedBooks
            self.totalPages = totalPages
        } catch {
            errorMessage = "Failed to fetch books. Please try again."
        }
        
        isLoading = false
    }
}

