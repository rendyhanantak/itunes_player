//
//  AudioPlayerService.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import AVFoundation
import Foundation

final class AudioPlayerService {
    private var player: AVPlayer?
    private var timeObserver: Any?

    var onProgressUpdate: ((Double, Double) -> Void)?
    var onPlaybackFinished: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    func play(url: URL) {
        removeTimeObserver()
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        addTimeObserver()
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func resume() {
        player?.play()
    }

    func seek(to seconds: Double) {
        let time = CMTime(
            seconds: seconds,
            preferredTimescale: 600
        )

        player?.seek(to: time)
    }

    func currentTime() -> Double {
        guard let player else {
            return 0
        }

        let seconds = player.currentTime().seconds

        return seconds.isFinite ? seconds : 0
    }

    func duration() -> Double {
        guard let player,
              let item = player.currentItem else {
            return 0
        }

        let seconds = item.duration.seconds

        return seconds.isFinite ? seconds : 0
    }

    private func addTimeObserver() {
        let interval = CMTime(
            seconds: 0.5,
            preferredTimescale: 600
        )

        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] _ in

            guard let self else {
                return
            }

            self.onProgressUpdate?(
                self.currentTime(),
                self.duration()
            )
        }
    }

    private func removeTimeObserver() {
        if let timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }

    @objc private func playerDidFinishPlaying(notification: Notification) {
        guard let finishedItem = notification.object as? AVPlayerItem,
              finishedItem === player?.currentItem else {
            return
        }

        onPlaybackFinished?()
    }

    deinit {
        removeTimeObserver()
        NotificationCenter.default.removeObserver(self)
    }
}
