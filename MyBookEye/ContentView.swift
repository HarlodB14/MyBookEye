import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var books: [Book] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTab: Tab = .search
    @State private var currentPage: Int = 1
    @State private var totalPages: Int = 1
    @State private var itemsPerPage: Int = 10

    let bookService = BookService()

    @StateObject private var bookmarkManager = BookmarkManager()

    enum Tab {
        case search, bookmarks
    }

    var body: some View {
        NavigationView {
            VStack {
                // Toggle voor switchen
                Picker("Selecteer een tabblad", selection: $selectedTab) {
                    Text("Zoeken").tag(Tab.search)
                    Text("Favorieten").tag(Tab.bookmarks)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

              
                switch selectedTab {
                case .search:
                    searchView
                case .bookmarks:
                    BookmarksView()
                        .environmentObject(bookmarkManager) // Pass BookmarkManager to BookmarksView
                }
            }
            .navigationBarTitle("My Book Eye", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(destination: BookmarksView().environmentObject(bookmarkManager)) {
                    Text("Favorieten")
                }
            )
        }
    }

    // Search View
    private var searchView: some View {
        VStack {
            TextField("Vul een titel van een boek", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

     
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

            
            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                // Error Message
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
           
                List(books, id: \.key) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            Text(book.author_name?.joined(separator: ", ") ?? "Onbekende Auteur")
                                .font(.subheadline)
                            if let year = book.firstPublishYear {
                                Text("Gepubliceerd op \(year)")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                    }
                    .swipeActions {
                        Button {
                            bookmarkManager.addBookmark(book: book, notes: "Voeg hier notities toe")
                        } label: {
                            Label("Bookmark", systemImage: "star.fill")
                        }
                        .tint(.yellow)
                    }
                }
            }

     
            HStack {
              
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

              
                Text("Page \(currentPage) of \(totalPages)")
                    .padding()

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
