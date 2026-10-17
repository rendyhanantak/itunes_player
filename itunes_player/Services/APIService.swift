//
//  APIService.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

final class APIService {
    func searchSongs(keyword: String) async throws -> [Song] {
        var components = URLComponents(
            string: "https://itunes.apple.com/search"
        )

        components?.queryItems = [
            URLQueryItem(name: "term", value: keyword),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "50")
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(
            from: url
        )

        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw APIError.invalidResponse
        }
        let searchResponse = try JSONDecoder().decode(
            SearchResponse.self,
            from: data
        )
        return searchResponse.results
    }
}
