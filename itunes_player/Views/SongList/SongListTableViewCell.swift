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

    func configure() {
        //TODO: remove this
        songNameLabel.text = "Song Name"
        artistLabel.text = "Artist Name"
        albumLabel.text = "Album Name"
    }

}
