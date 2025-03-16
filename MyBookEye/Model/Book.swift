//
//  Book.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//

struct Book: Identifiable, Decodable {
    var key: String
    var title: String
    var author_name: [String]?
    var firstPublishYear: Int?
    var editionCount: Int?
    var languageName: [String]?


    var id: String {
        return key
    }
   
}

