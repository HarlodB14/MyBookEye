//
//  BookService.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//
import Foundation

struct BookService {
    
    func fetchBooks(query: String) async throws -> [Book] {
        //zoekquery opzetten en valideren
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openlibrary.org/search.json?q=\(query)") else {
            print("Invalid URL: \(query)")
            throw URLError(.badURL)
        }
        
        print("Fetching books with: \(url.absoluteString)")
        
        
        // boek data ophalen
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode the data into an OpenLibraryResponse object
        do {
            let apiResponse = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
            let books = apiResponse.docs.map { doc -> Book in
                return Book(
                    key: doc.key,
                    title: doc.title,
                    author_name: doc.author_name,
                    coverImageURL: doc.coverImageURL,
                    firstPublishYear: doc.firstPublishYear,
                    editionCount: doc.editionCount,
                    languageName: doc.languageName
                )
            }
            return books
        } catch {
            print("Error decoding response: \(error)")
            print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            throw error
        }
        
    }
}



