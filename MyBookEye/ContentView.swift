import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var books: [Book] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTab: Tab = .search

    let bookService = BookService()

    @StateObject private var bookmarkManager = BookmarkManager()

    enum Tab {
        case search, bookmarks
    }

    var body: some View {
        NavigationView {
            VStack {
                // Toggle for switching between Search and Bookmarks
                Picker("Selecteer een tabblad", selection: $selectedTab) {
                    Text("Zoeken").tag(Tab.search)
                    Text("Favorieten").tag(Tab.bookmarks)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Show content based on selected tab
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
                    Text("Bookmarks")
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
                    isLoading = true
                    errorMessage = nil
                    do {
                        let fetchedBooks = try await bookService.fetchBooks(query: query)
                        books = fetchedBooks
                    } catch {
                        errorMessage = "Fout met het zoeken naar een boek"
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

                        Text(book.author_name?.joined(separator: ", ") ?? "Onbekende Auteur")
                            .font(.subheadline)

                        if let year = book.firstPublishYear {
                            Text("Gepubliceerd op \(year)")
                                .font(.subheadline)
                        }
                    }
                    .padding()
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
        }
        .padding()
    }
}
