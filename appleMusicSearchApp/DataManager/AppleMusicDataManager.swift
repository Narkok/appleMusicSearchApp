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
    let artistListResult = PublishRelay<Event<[Artist]>>()
    static private let provider = MoyaProvider<AppleMusicAPIRequest>()
    
    func getArtistList(byName name: String, withOffset offset: Int) {
        AppleMusicDataManager.provider.request(.searchArtist(name: name, offset: offset), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print(response)
                guard let returnData = String(data: response.data, encoding: .utf8) else { return }
                print(returnData)
                
            case .failure: self.artistListResult.accept(.error(AMDMError(message: "Ошибка при запросе данных")))
                
            }
        })
    }
    
    struct AMDMError: Error {
        let message: String
    }
}
