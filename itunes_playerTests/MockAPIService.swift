//
//  MockAPIService.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import Foundation
@testable import itunes_player

class MockAPIService: APIService {
    var mockSongs: [Song] = []
    var shouldThrowError = false
    var searchSongsCallCount = 0
    var receivedKeyword: String?

    override func searchSongs(keyword: String) async throws -> [Song] {
        searchSongsCallCount += 1
        receivedKeyword = keyword

        if shouldThrowError {
            throw NSError(
                domain: "MockAPIServiceError",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Something went wrong"
                ]
            )
        }
        return mockSongs
    }
}
