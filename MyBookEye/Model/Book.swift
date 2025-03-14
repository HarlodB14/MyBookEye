//
//  Book.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//

struct Book: Identifiable, Codable {
    var key: String   // This is the unique identifier from the API
    var title: String
    var author_name: [String]?
    var firstPublishYear: Int?
    var editionCount: Int?
    var languageName: [String]?

    // Computed property to return key as id for Identifiable conformance
    var id: String {
        return key
    }
   
}

