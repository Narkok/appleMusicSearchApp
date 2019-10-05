//
//  SongCell.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 28/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songAlbumLabel: UILabel!
    
    func setup(title: String?, album: String?, artworkURL: String?)  {
        songTitleLabel.text = title
        songAlbumLabel.text = album
        if let artworkUrl = artworkURL, let url = URL(string: artworkUrl) { albumImageView.kf.setImage(with: url) }
    }
}
