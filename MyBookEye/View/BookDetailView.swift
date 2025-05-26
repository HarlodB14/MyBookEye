import SwiftUI

struct BookDetailView: View {
    var book: Book

    var body: some View {
        VStack {
            Text(book.title)
                .font(.largeTitle)
                .padding()

            if let authors = book.author_name?.joined(separator: ", ") {
                Text("Auteur(s): \(authors)")
                    .font(.title2)
                    .padding(.bottom)
            } else {
                Text("Auteur(s): Onbekend")
                    .font(.title2)
                    .padding(.bottom)
            }

            Text("Geplaatst in: \(formattedYear(from: book.firstPublishYear))")
                .font(.title3)
                .padding(.bottom)

            if let languages = book.languageName?.joined(separator: ", ") {
                Text("Taal(en): \(languages)")
                    .font(.title3)
                    .padding(.bottom)
            } else {
                Text("Taal(en): Onbekend")
                    .font(.title3)
                    .padding(.bottom)
            }

            if let editionCount = book.editionCount {
                Text("Aantal edities: \(editionCount)")
                    .font(.title3)
                    .padding(.bottom)
            } else {
                Text("Aantal edities: Onbekend")
                    .font(.title3)
                    .padding(.bottom)
            }

            Spacer()
        }
        .navigationTitle("Boek Details")
        .padding()
    }

    func formattedYear(from year: Int?) -> String {
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
