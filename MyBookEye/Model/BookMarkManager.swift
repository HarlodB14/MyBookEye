//
//  BookMarkManager.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 14/03/2025.
//
import Foundation

class BookmarkManager: ObservableObject {
    @Published var bookmarks: [BookmarkedBook] = []

    private let bookmarksKey = "bookmarks"
    

    init() {
        loadBookmarks()
    }

    // Add a new bookmark to the list
    func addBookmark(book: Book, notes: String) {
        let bookmarkedBook = BookmarkedBook(book: book, notes: notes)
        bookmarks.append(bookmarkedBook)
        saveBookmarks()
    }
    


    func deleteBookmark(id: UUID) {
        bookmarks.removeAll { $0.id == id }
        saveBookmarks()
    }

    // Save bookmarks to UserDefaults
    public func saveBookmarks() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        }
    }
    
    func getBookmarks() -> [BookmarkedBook] {
           return bookmarks
       }

    // Load saved bookmarks from UserDefaults
    private func loadBookmarks() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: bookmarksKey),
           let savedBookmarks = try? decoder.decode([BookmarkedBook].self, from: data) {
            bookmarks = savedBookmarks
        }
    }
}
