//
//  SearchResponse.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import Foundation

struct SearchResponse: Codable {
    let resultCount: Int
    let results: [Song]
}
