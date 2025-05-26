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
    //landscape state checken
    @State private var isLandscape: Bool = false
    @State private var showSearchInLandscape: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let isLandscapeNow = geometry.size.width > geometry.size.height
                VStack {
                    Picker("Selecteer een tabblad", selection: $selectedTab) {
                        Text("Zoeken").tag(Tab.search)
                        Text("Favorieten").tag(Tab.bookmarks)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Group {
                        switch selectedTab {
                        case .search:
                            searchView(isLandscape: isLandscapeNow, showSearch: showSearchInLandscape)
                        case .bookmarks:
                            BookmarksView()
                                .environmentObject(bookmarkManager)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onAppear {
                    isLandscape = isLandscapeNow
                }
                .onChange(of: isLandscapeNow) { newValue in
                    isLandscape = newValue
                    if !newValue {
                        // Reset search UI visible in portrait
                        showSearchInLandscape = false
                    }
                }
                .navigationBarTitle("My Book Eye", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isLandscape && selectedTab == .search {
                            Button(action: {
                                withAnimation {
                                    showSearchInLandscape.toggle()
                                }
                            }) {
                                Image(systemName: showSearchInLandscape ? "xmark.circle.fill" : "magnifyingglass")
                                    .imageScale(.large)
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func searchView(isLandscape: Bool, showSearch: Bool) -> some View {
        VStack {
            // Show search bar & button if portrait OR landscape
            if !isLandscape || showSearch {
                TextField("Vul een titel van een boek", text: $query)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    Task {
                        currentPage = 1
                        await fetchBooks()
                        if isLandscape {
                            withAnimation {
                                showSearchInLandscape = false
                            }
                        }
                    }
                }) {
                    Text("Search")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom)
            }

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(books, id: \.key) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            Text(book.author_name?.joined(separator: ", ") ?? "Onbekende Auteur")
                                .font(.subheadline)
                            if let year = book.firstPublishYear {
                                Text("Gepubliceerd op \(formattedYear(from: year))")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 5)
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
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if (!isLandscape || showSearch) {
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
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func fetchBooks() async {
        isLoading = true
        errorMessage = nil

        do {
            let (fetchedBooks, totalPages) = try await bookService.fetchBooks(
                query: query,
                page: currentPage,
                itemsPerPage: itemsPerPage
            )
            books = fetchedBooks
            self.totalPages = totalPages
        } catch {
            errorMessage = "Failed to fetch books. Please try again."
        }

        isLoading = false
    }

    private func formattedYear(from year: Int?) -> String {
        guard let year = year,
              let date = Calendar.current.date(from: DateComponents(year: year)) else {
            return "Onbekend"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter.string(from: date)
    }
}
