//
//  ArtistSearchViewModel.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 12/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import RxCocoa
import RxSwift

class ArtistSearchViewModel {
    
    static private let dataManager = AppleMusicDataManager()
    
    
    struct Input {
        let searchText = PublishRelay<String>()
    }
    
    struct Output {
        let artists: Driver<[Artist]>
    }
    
    let input = Input()
    let output: Output
    
    
    init() {
        let artistToSearch = input.searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
        
        /// Результат запроса
        let responseResult = artistToSearch.flatMapLatest { name -> PublishRelay<Event<[Artist]>> in
            return ArtistSearchViewModel.dataManager.getArtistList(byName: name, withOffset: 0)
        }.share()
        
        /// Список полученных исполнителей
        let artists = responseResult
            .map { $0.element }
            .filter { $0 != nil }
            .map{ $0! }
        
        output = Output(artists: artists.asDriver(onErrorJustReturn: []))
    }
}
