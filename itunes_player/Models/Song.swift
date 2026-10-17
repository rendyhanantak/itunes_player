//
//  Song.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import Foundation

struct Song: Codable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: URL?
    let previewUrl: URL?

    enum CodingKeys: String, CodingKey {
        case trackId
        case trackName
        case artistName
        case collectionName
        case artworkUrl100
        case previewUrl
    }
}
