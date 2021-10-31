//
//  SearchMovie.swift
//  movies_app
//
//  Created by Uno qualunque on 18/10/21.
//

import Foundation

struct SearchMovie: Codable {
    let id: Int
    let logo_path: String?
    let name: String
    let origin_country: String
}
