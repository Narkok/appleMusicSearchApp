//
//  AlbumsCell.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 28/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import UIKit

class AlbumsCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    func setup(albums: [Album]) {
        
        
        for album in albums {
//            print(album)
            let albumView = AlbumView()
            
            albumView.albumNameLabel.text = album.collectionName
            if let artworkUrl = album.artworkUrl100, let url = URL(string: artworkUrl) { albumView.albumImageView.kf.setImage(with: url) }
            stackView.addArrangedSubview(albumView)
        }
    }
    
}
