//
//  Model.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 19/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//


/// Структура для списка исполнителей
struct ArtistsResponse: Codable {
    let results: [Artist]
}

/// Структура для исполнителя
struct Artist: Codable {
    let artistName: String
    let artistId: Int
    let primaryGenreName: String?
}


/// Структура для списка песен
struct SongsResponse: Codable {
    let results: [Song]
}

/// Структура для песни
struct Song: Codable {
    let wrapperType: String
    let trackName: String?
    let collectionName: String?
    let artworkUrl100: String?
}


/// Структура для списка альбомов
struct AlbumsResponse: Codable {
    let results: [Album]
}

/// Структура для песни
struct Album: Codable {
    let wrapperType: String
    let collectionName: String?
    let artworkUrl100: String?
}

