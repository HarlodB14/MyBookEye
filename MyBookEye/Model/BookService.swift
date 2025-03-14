//
//  BookService.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//
import Foundation

struct BookService {
    
    func fetchBooks(query: String, page: Int, itemsPerPage: Int) async throws -> (books: [Book], totalPages: Int) {
        // Validate query and build URL for pagination
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openlibrary.org/search.json?q=\(query)&page=\(page)&limit=\(itemsPerPage)") else {
            print("Invalid URL: \(query)")
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Log the raw response data for inspection
        print(String(data: data, encoding: .utf8) ?? "No valid data returned")

        // Decode the response
        let apiResponse = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
        
        // Calculate totalPages (assuming the API returns a total count of items)
        let totalPages = (apiResponse.numFound / itemsPerPage) + (apiResponse.numFound % itemsPerPage == 0 ? 0 : 1)

        // Map API response to Book model
        let books = apiResponse.docs.map { doc -> Book in
            return Book(
                key: doc.key,
                title: doc.title,
                author_name: doc.author_name,
                firstPublishYear: doc.firstPublishYear,
                editionCount: doc.editionCount,
                languageName: doc.languageName
            )
        }

        return (books, totalPages)
    }
}




