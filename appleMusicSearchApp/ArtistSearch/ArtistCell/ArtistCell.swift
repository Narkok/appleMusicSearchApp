//
//  ArtistCell.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 21/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        /// Установка цвета фона выделенной ячейки
        backgroundColor = .init(white: highlighted ? 0.9 : 1, alpha: 1)
    }
    
    
    func setup(name: String, genre: String) {
        nameLabel.text = name
        genreLabel.text = genre
    }
    
}
