//
//  Book.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//

struct Book: Identifiable, Codable {
    var key: String
    var title: String
    var author_name: [String]?
    var firstPublishYear: Int?
    var editionCount: Int?
    var languageName: [String]?


    var id: String {
        return key
    }
    //mapping naar json-key
    
    enum CodingKeys: String, CodingKey {
          case key
          case title
          case author_name
          case firstPublishYear = "first_publish_year"
          case editionCount = "edition_count"
          case languageName = "language"
      }
   
}

