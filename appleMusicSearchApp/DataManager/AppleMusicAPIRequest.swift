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
}


extension AppleMusicAPIRequest: TargetType {
    var baseURL: URL { return appleMusicBaseURL }
    
    var path: String {
        switch self {
        case .searchArtist:
            return "search"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchArtist(let name, let offset):
            return ["term": name,
                    "entity": "musicArtist",
                    "limit": 50,
                    "offset": offset
            ]
        }
    }
    
    var method: Method { return .get }
    var sampleData: Data { return "{}".data(using: .utf8)! }
    var task: Task { return .requestPlain }
    var headers: [String : String]? { return ["Content-Type": "application/json"] }
}
