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
    
    private let artistListResult = PublishRelay<Event<[Artist]>>()
    static private let provider = MoyaProvider<AppleMusicAPIRequest>()
    
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
}


struct AMDMError: Error {
    let message: String
}
