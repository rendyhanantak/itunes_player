//
//  SongListViewModel.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import Foundation

@MainActor
final class SongListViewModel {
    private let apiService: APIService
    private(set) var songs: [Song] = []

    var onSongsUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func searchSongs(keyword: String) {
        Task {
            await fetchSongs(keyword: keyword)
        }
    }

    private func fetchSongs(keyword: String) async {
        onLoadingChanged?(true)
        defer {
            onLoadingChanged?(false)
        }
        do {
            songs = try await apiService.searchSongs(
                keyword: keyword
            )
            onSongsUpdated?()
        } catch {
            onError?(
                "Unable to load songs. Please try again."
            )
        }
    }
    
    func totalSongs() -> Int {
        songs.count
    }

    func song(position: Int) -> Song {
        songs[position]
    }
}
