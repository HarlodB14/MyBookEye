//
//  Bookdoc.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 10/03/2025.
//
struct BookDoc: Decodable {
    let key: String
    let title: String
    let author_name: [String]?  // Updated to match the API response key
    let first_publish_year: Int?
    let edition_count: Int?
    let language: [String]?
    

    // Computed property for the first author, or "Unknown Author" if no authors are found
    var authorName: String {
        return author_name?.first ?? "Onbekende Auteur"  // Safely unwrap the first author or return a default value
    }

    // Computed property for first publish year, or "Unknown Year" if no year is available
    var publishYear: String {
        return first_publish_year.map { "\($0)" } ?? "Geen Datum beschikbaar"
    }

    // Computed property for the number of editions, or "Unknown Edition Count"
    var editionCount: String {
        return edition_count.map { "\($0)" } ?? "Onbekende Editie"
    }

    // Computed property for language, or "Unknown Language" if no language is found
    var languageName: String {
        return language?.first ?? "Geen taal gevonden"
    }
}
