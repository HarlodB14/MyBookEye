import SwiftUI

struct ContentView: View {
    @State private var query: String = ""  // Query input
    @State private var books: [Book] = []  // Array of books to display
    @State private var isLoading = false  // Loading state
    @State private var errorMessage: String?  // Error message state

    let bookService = BookService()  // Instance of the BookService to fetch books

    var body: some View {
        VStack {
            // Input text field for search query
            TextField("Enter book title", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Search button to trigger fetching books
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

            // Loading indicator
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = errorMessage {
                // Display error message if any
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // List of books
                List(books, id: \.key) { book in
                    VStack(alignment: .leading) {
                        // Display the book title
                        Text(book.title)
                            .font(.headline)

                        // Display the author name(s)
                        Text(book.authorName)
                            .font(.subheadline)

                        // Display the publication year
                        Text("Published in \(book.firstPublishYear)")
                            .font(.subheadline)

                        // Show the book cover image if available
                        if let coverImageURL = book.coverImageURL {
                            AsyncImage(url: URL(string: coverImageURL)) { image in
                                image.resizable()
                                     .scaledToFit()
                                     .frame(width: 100, height: 150)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }

    // Fetch books based on query
    private func fetchBooks() async {
        guard !query.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            // Fetch books from the API using the query
            let fetchedBooks = try await bookService.fetchBooks(query: query)

            // Map the fetched books to the Book model
            books = fetchedBooks.map { bookDoc in
                return Book(
                    key: bookDoc.key,
                    title: bookDoc.title,
                    authorName: bookDoc.authorName,
                    coverImageURL: bookDoc.coverImageURL,
                    firstPublishYear: bookDoc.firstPublishYear,
                    editionCount: bookDoc.editionCount,
                    languageName: bookDoc.languageName
                )
            }
        } catch {
            // Handle errors and display a message
            errorMessage = "Failed to fetch books: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

