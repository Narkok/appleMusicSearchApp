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
        let cells: Driver<[CellType]>
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
        
        
        /// Комбинированный список из песен и альбомов
        let result = Observable.combineLatest(albums, songs)
            .map { (albums: $0, songs: $1) }
        result.subscribe().disposed(by: disposeBag)
        
        /// Список ячеек для tableView
        let cells = result.map { result -> [CellType] in
            var cells = [CellType]()
            cells.append(.albums(list: result.albums))
            result.songs.forEach { cells.append(.song(info: $0)) }
            return cells
        }.asDriver(onErrorJustReturn: [])
        
        output = Output(cells: cells)
    }
}


extension ArtistInfoViewModel {
    /// Типы ячеек для tableView
    enum CellType {
        /// Ячейка со списком альбомов
        case albums(list: [Album])
        /// Ячейка песни
        case song(info: Song)
    }
}
