//
//  Bookdoc.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 10/03/2025.
//
struct BookDoc: Decodable {
    let key: String
    let title: String
    let author_name: [String]  
    let first_publish_year: Int?
    let edition_count: Int?
    let language: [String]?

    // Custom initializer for safe decoding
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)

         key = try container.decode(String.self, forKey: .key)
         title = try container.decode(String.self, forKey: .title)
         
         // Use decodeIfPresent for author_name to avoid issues if it's missing
         author_name = try container.decodeIfPresent([String].self, forKey: .author_name) ?? ["Onbekende Auteur"]
         
         first_publish_year = try container.decodeIfPresent(Int.self, forKey: .first_publish_year)
         edition_count = try container.decodeIfPresent(Int.self, forKey: .edition_count)
         language = try container.decodeIfPresent([String].self, forKey: .language)
     }
    
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case author_name
        case first_publish_year
        case edition_count
        case language
    }

    // Computed properties for safe fallback values
    var authorName: String {
        return author_name.first ?? "onbekende auteur"  // Default value if author_name is nil
    }

    var publishYear: String {
        return first_publish_year.map { "\($0)" } ?? "Datum onbekend"
    }

    var editionCount: String {
        return edition_count.map { "\($0)" } ?? "Onbekende Editie"
    }

    var languageName: String {
        return language?.first ?? "Onbekende Taal"
    }
}
