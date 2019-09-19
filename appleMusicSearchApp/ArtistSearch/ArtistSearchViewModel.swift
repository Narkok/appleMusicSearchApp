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
    
    private let dataManager = AppleMusicDataManager()
    
    
    struct Input {
        let searchText = PublishRelay<String>()
    }
    
//    struct Output {
//        let text: Driver<String>
//    }
    
    let input = Input()
//    let output: Output
    
    
    init() {
        let artistToSearch = input.searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "Error")
        
//        output = Output(text: artistToSearch)
        
        dataManager.getArtistList(byName: "lana", withOffset: 0)
    }
}
