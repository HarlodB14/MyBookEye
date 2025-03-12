//
//  Book.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//

struct Book: Identifiable, Decodable {
    let key: String   // This is the unique identifier from the API
    let title: String
    let authorName: String
    let coverImageURL: String?
    let firstPublishYear: String
    let editionCount: String
    let languageName: String

    // Computed property to return key as id for Identifiable conformance
    var id: String {
        return key
    }
}

