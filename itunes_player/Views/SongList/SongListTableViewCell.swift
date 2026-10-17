//
//  SongListTableViewCell.swift
//  itunes_player
//
//  Created by Rendy Hananta on 17/10/26.
//

import UIKit

class SongListTableViewCell: UITableViewCell {
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var playingStateImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        songImageView.image = nil
        playingStateImageView.isHidden = true
        songNameLabel.text = nil
        artistLabel.text = nil
        albumLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(song: Song, playedTrackId: Int? = nil) {
        songNameLabel.text = song.trackName
        artistLabel.text = song.artistName
        albumLabel.text = song.collectionName
        
        if playedTrackId == song.trackId {
            playingStateImageView.isHidden = false
        } else {
            playingStateImageView.isHidden = true
        }
        
        guard let artworkURL = song.artworkUrl100 else {
            return
        }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(
                    from: artworkURL
                )
                guard let image = UIImage(data: data) else {
                    return
                }
                await MainActor.run {
                    self.songImageView.image = image
                }
            } catch {
                self.songImageView.image = UIImage(named: "icon_no_image")
            }
        }
    }

}
