//
//  ArtistInfoViewModel.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 21/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import RxCocoa
import RxSwift

class ArtistInfoViewModel {
    
    static private let dataManager = AppleMusicDataManager()
    private let disposeBag = DisposeBag()
    
    
    struct Input {
        let loadDataForArtistID = PublishRelay<Int>()
    }
    
    struct Output {
        let songs: Driver<[Song]>
        let albums: Driver<[Album]>
    }
    
    let input = Input()
    let output: Output
    
    
    init() {
        
        /// Загрузка списка песен
        let songsData = input.loadDataForArtistID
            .flatMapLatest { artistID -> PublishRelay<Event<[Song]>> in
                return ArtistInfoViewModel.dataManager.getSongsFromArtistBy(id: artistID)
            }.share()
        
        
        /// Список песен исполнителя
        let songs = songsData
            .map { $0.element }
            .filter { $0 != nil }
            .map{ $0! }
            .map { $0.filter { $0.wrapperType == "track" } }
            .asDriver(onErrorJustReturn: [])
        songs.drive().disposed(by: disposeBag)
        
        
        /// Загрузка списка альбомов
        let albumsData = input.loadDataForArtistID
            .flatMapLatest { artistID -> PublishRelay<Event<[Album]>> in
                return ArtistInfoViewModel.dataManager.getAlbumsFromArtistBy(id: artistID)
            }.share()
        
        
        /// Список альбомов исполнителя
        let albums = albumsData
            .map { $0.element }
            .filter { $0 != nil }
            .map{ $0! }
            .map { $0.filter { $0.wrapperType == "collection" } }
            .asDriver(onErrorJustReturn: [])
        albums.drive().disposed(by: disposeBag)
        
        output = Output(songs: songs, albums: albums)
    }
}
