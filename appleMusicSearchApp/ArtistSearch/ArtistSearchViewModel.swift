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
    
    /// Массив исполнителей
    static private var artists = [Artist]()
    
    /// DataManager для загрузки списка иполнителей
    static private let dataManager = AppleMusicDataManager()
    

    /// Входы из контроллера
    struct Input {
        let searchText = PublishRelay<String>()
        let offset = BehaviorRelay<Int>(value: 0)
    }
    
    /// Выходы в контроллер
    struct Output {
        let artists: Driver<[Artist]>
    }
    
    let input = Input()
    let output: Output

    
    init() {
        
        /// Имя исполнителя для поиска
        let artistToSearch = input.searchText
        
        
        /// Результат запроса
        let responseResult = Observable.combineLatest(artistToSearch, input.offset)
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .flatMapLatest { name, offset -> PublishRelay<Event<[Artist]>> in
                /// Очистить список, если offset == 0
                if offset == 0 { ArtistSearchViewModel.artists = [] }
                /// Загрузить и вернуть список исполнителей
                return ArtistSearchViewModel.dataManager.getArtistList(byName: name, withOffset: offset)
            }.share()
        
    
        /// Список полученных исполнителей
        let artists = responseResult
            .map { $0.element }
            .filter { $0 != nil }
            .map { $0! }
            .map { newPage -> [Artist] in
                /// Добавление новых загруженных исполнителей к списку имеющихся
                ArtistSearchViewModel.artists += newPage
                return ArtistSearchViewModel.artists
            }
        
        
        /// Ошибка
        let error = responseResult
            .map { $0.error }
            .filter { $0 != nil }
            .map { $0 }
        
        
        output = Output(artists: artists.asDriver(onErrorJustReturn: []))
    }
}
