//
//  Movie.swift
//  movies_app
//
//  Created by Uno qualunque on 28/09/21.
//

import Foundation

struct Movie: Codable {
    var title: String
    var vote_average: Float
    var original_language: String
    var release_date: String
    var poster_path: String?
    var backdrop_path: String?
    var overview: String
    var original_title: String
    var popularity: Float
}
