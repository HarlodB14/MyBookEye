//
//  OpenLibraryResponse.swift
//  MyBookEye
//
//  Created by Harlod Bombala on 12/03/2025.
//

import Foundation

struct OpenLibraryResponse: Decodable {
    let docs: [Book]
    let numFound: Int
}
