//
//  CustomPlayerModel.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import Foundation

@MainActor
final class CustomPlayerModel {
    private let audioService: AudioPlayerService
    private(set) var songs: [Song]
    private(set) var currentIndex: Int
    private(set) var isPlaying = false
    private(set) var currentTime: Double = 0
    private(set) var duration: Double = 0

    var onSongChanged: ((Song) -> Void)?
    var onPlaybackStateChanged: ((Bool) -> Void)?
    var onProgressChanged: ((Double, Double) -> Void)?

    var currentSong: Song {
        songs[currentIndex]
    }

    init(songs: [Song], selectedIndex: Int, audioService: AudioPlayerService?) {
        self.songs = songs
        self.currentIndex = selectedIndex
        self.audioService = audioService ?? AudioPlayerService()
        configureAudioCallbacks()
    }

    private func configureAudioCallbacks() {
        audioService.onProgressUpdate = {
            [weak self] currentTime, duration in

            guard let self else {
                return
            }

            self.currentTime = currentTime
            self.duration = duration

            self.onProgressChanged?(
                currentTime,
                duration
            )
        }

        audioService.onPlaybackFinished = {
            [weak self] in

            self?.playNext()
        }
    }

    func play() {
        guard let url = currentSong.previewUrl else {
            onPlaybackStateChanged?(false)
            return
        }
        audioService.play(url: url)
        isPlaying = true
        onPlaybackStateChanged?(true)
        onSongChanged?(currentSong)
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            if currentTime == 0 && duration == 0 {
                play()
                return
            }
            audioService.resume()
            isPlaying = true
        }

        onPlaybackStateChanged?(isPlaying)
    }

    func playNext() {
        guard !songs.isEmpty else {
            return
        }
        currentIndex = (currentIndex + 1) % songs.count
        play()
    }

    func playPrevious() {
        guard !songs.isEmpty else {
            return
        }
        currentIndex = (
            currentIndex - 1 + songs.count
        ) % songs.count
        play()
    }

    func seek(to value: Double) {
        audioService.seek(to: value)
    }
    
    func reset(to index: Int = 0) {
        audioService.pause()
        isPlaying = false
        self.currentIndex = index
        self.currentTime = 0
    }
}
