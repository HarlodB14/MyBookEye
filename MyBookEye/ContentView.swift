import SwiftUI

struct ContentView: View {
    @State private var query: String = ""  // Query input (value)
    @State private var books: [Book] = []  // Array of books to display
    @State private var isLoading = false  // Loading state
    @State private var errorMessage: String?  // Error message state

    let bookService = BookService()  // Instance of the BookService to fetch books

    var body: some View {
        VStack {
            // Input text field for search query
            TextField("Enter book title", text: $query)  // $query is the binding
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Search button to trigger fetching books
            Button(action: {
                Task {
                    try await bookService.fetchBooks(query : query)  // Pass the actual value of query
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
                List($books, id: \.key) { book in
                    VStack(alignment: .leading) {
                        // Display the book title
                        Text("\(book.title)" )
                            .font(.headline)

                        // Display the author name(s)
                        Text("\(book.author_name) ")
                            .font(.subheadline)

                        // Display the publication year
                        Text("Published in \(book.firstPublishYear)")
                            .font(.subheadline)
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

