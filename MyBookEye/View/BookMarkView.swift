import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var bookmarkManager: BookmarkManager

    var body: some View {
        NavigationView {
            List {
                // Loop through the bookmarked books using ForEach
                ForEach(bookmarkManager.bookmarks) { bookmarkedBook in
                    // Pass BookmarkManager to BookmarkedBookView
                    BookmarkedBookView(bookmarkedBook: bookmarkedBook)
                        .onChange(of: bookmarkedBook.notes) { newNotes in
                            // Update the notes in the BookmarkManager whenever changed
                            if let index = bookmarkManager.bookmarks.firstIndex(where: { $0.id == bookmarkedBook.id }) {
                                bookmarkManager.bookmarks[index].notes = newNotes
                                bookmarkManager.saveBookmarks()
                            }
                        }
                }
            }
            .navigationBarTitle("Bookmarks")
        }
    }
}


struct BookmarkedBookView: View {
    @EnvironmentObject var bookmarkManager: BookmarkManager
    var bookmarkedBook: BookmarkedBook
    @State private var editedNotes: String

    init(bookmarkedBook: BookmarkedBook) {
        self.bookmarkedBook = bookmarkedBook
        _editedNotes = State(initialValue: bookmarkedBook.notes)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(bookmarkedBook.book.title)
                .font(.headline)

            Text(bookmarkedBook.book.author_name?.joined(separator: ", ") ?? "Unknown Author")
                .font(.subheadline)

            // Use TextEditor to edit notes
            TextEditor(text: $editedNotes)
                .frame(height: 80)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))

            // Remove bookmark button
            Button(role: .destructive) {
                // Delete the bookmark using the BookmarkManager instance from @EnvironmentObject
                bookmarkManager.deleteBookmark(id: bookmarkedBook.id)
            } label: {
                Label("Remove Bookmark", systemImage: "trash")
            }
        }
        .padding(.vertical, 8)
        .onChange(of: editedNotes) { newNotes in
            // Update the notes locally when the TextEditor content changes
            // You could use this closure to notify the parent view, if necessary
            if let index = bookmarkManager.bookmarks.firstIndex(where: { $0.id == bookmarkedBook.id }) {
                bookmarkManager.bookmarks[index].notes = newNotes
                bookmarkManager.saveBookmarks()
            }
        }
    }
}
