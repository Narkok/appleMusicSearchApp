//
//  AppleMusicAPIRequest.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 19/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import Moya

private let appleMusicBaseURL = URL(string: "https://itunes.apple.com")!

enum AppleMusicAPIRequest {
    case searchArtist(name: String, offset: Int)
    case searchSongs(id: Int)
    case searchAlbums(id: Int)
}


extension AppleMusicAPIRequest: TargetType {
    var baseURL: URL { return appleMusicBaseURL }
    
    var path: String {
        switch self {
        case .searchArtist:
            return "search"
        case .searchSongs, .searchAlbums:
            return "lookup"
        }
    }
    
    var task: Task {
        switch self {
        case .searchArtist(let name, let offset):
            return .requestParameters(parameters: ["term": name,
                                                   "entity": "musicArtist",
                                                   "limit": 50,
                                                   "offset": offset],
                                      encoding: URLEncoding.default)
            
        case .searchSongs(let id):
            return .requestParameters(parameters: ["id": id,
                                                   "entity": "song"],
                                      encoding: URLEncoding.default)
            
        case .searchAlbums(let id):
            return .requestParameters(parameters: ["id": id,
                                                   "entity": "album"],
                                      encoding: URLEncoding.default)
        }
    }
    
    var method: Moya.Method { return .get }
    var sampleData: Data { return "{}".data(using: .utf8)! }
    var headers: [String : String]? { return ["Content-Type": "application/json"] }
}
