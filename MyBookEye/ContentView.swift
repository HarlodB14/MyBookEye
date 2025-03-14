import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var books: [Book] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    let bookService = BookService()

    var body: some View {
        VStack {
            TextField("Enter book title", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                Task {
                    isLoading = true
                    errorMessage = nil
                    do {
                        let fetchedBooks = try await bookService.fetchBooks(query: query)
                        books = fetchedBooks
                    } catch {
                        errorMessage = "Failed to fetch books. Please try again."
                    }
                    isLoading = false
                }
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
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
        }
        .padding()
    }
}
