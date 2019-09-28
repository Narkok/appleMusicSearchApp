//
//  AppleMusicDataManager.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 19/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

class AppleMusicDataManager {
    
    static private let provider = MoyaProvider<AppleMusicAPIRequest>()
    
    private let artistListResult = PublishRelay<Event<[Artist]>>()
    private let albumsDataResult = PublishRelay<Event<[Album]>>()
    private let songsDataResult = PublishRelay<Event<[Song]>>()
    
    
    /// Получить список исполнителей по имени
    func getArtistList(byName name: String, withOffset offset: Int) -> PublishRelay<Event<[Artist]>> {
        AppleMusicDataManager.provider.request(.searchArtist(name: name, offset: offset), completion: { [weak self] result in
            guard let self = self else { return }
        
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(ArtistsResponse.self, from: response.data)
                    self.artistListResult.accept(.next(data.results))
                }
                catch { self.artistListResult.accept(.error(AMDMError(message: "Ошибка при парсинге данных: \(error)"))) }
            case .failure: self.artistListResult.accept(.error(AMDMError(message: "Ошибка при запросе данных")))
            }
        })
        
        return artistListResult
    }
    
    
    /// Получить список песен исполнителя по его id
    func getSongsFromArtistBy(id: Int) -> PublishRelay<Event<[Song]>> {
        AppleMusicDataManager.provider.request(.searchSongs(id: id), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(SongsResponse.self, from: response.data)
                    self.songsDataResult.accept(.next(data.results))
                }
                catch { self.songsDataResult.accept(.error(AMDMError(message: "Ошибка при парсинге данных: \(error)"))) }
            case .failure: self.songsDataResult.accept(.error(AMDMError(message: "Ошибка при запросе данных")))
            }
        })
        
        return songsDataResult
    }
    
    
    /// Получить список альбомов исполнителя по его id
    func getAlbumsFromArtistBy(id: Int) -> PublishRelay<Event<[Album]>> {
        AppleMusicDataManager.provider.request(.searchAlbums(id: id), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(AlbumsResponse.self, from: response.data)
                    self.albumsDataResult.accept(.next(data.results))
                }
                catch { self.albumsDataResult.accept(.error(AMDMError(message: "Ошибка при парсинге данных: \(error)"))) }
            case .failure: self.albumsDataResult.accept(.error(AMDMError(message: "Ошибка при запросе данных")))
            }
        })
        
        return albumsDataResult
    }
    
}


struct AMDMError: Error {
    let message: String
}
