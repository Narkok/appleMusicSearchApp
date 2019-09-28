//
//  ArtistInfoController.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 21/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistInfoController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var artist: Artist?
    private let viewModel = ArtistInfoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let artist = artist else { return }
        title = artist.artistName
        
        /// Загрузить список песен и альбомов исполнителя
        viewModel.input.loadDataForArtistID.accept(artist.artistId)
        
        viewModel.output.songs.drive(onNext:{
            $0.forEach { print ($0.trackName) }
            print("====")
        }).disposed(by: disposeBag)
        
        viewModel.output.albums.drive(onNext:{
            $0.forEach { print ($0.collectionName) }
            print("====")
        }).disposed(by: disposeBag)
    }
}

