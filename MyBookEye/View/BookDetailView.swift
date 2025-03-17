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

            if let year = book.firstPublishYear {
                Text("Geplaatst in: \(Int(year))")
                    .font(.title3)
                    .padding(.bottom)
            } else {
                Text("Geplaatst in: Onbekend")
                    .font(.title3)
                    .padding(.bottom)
            }

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
}
