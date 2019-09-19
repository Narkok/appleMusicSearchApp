//
//  Model.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 19/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

struct Artist: Codable {
    let artistName: String
    let artistLinkUrl: String
    let artistId: Int
    let amgArtistId: Int
    let primaryGenreName: String
}
