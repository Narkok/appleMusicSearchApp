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
import Kingfisher

class ArtistInfoController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var artist: Artist?
    private let viewModel = ArtistInfoViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let artist = artist else { return }
        title = artist.artistName
        
        
        /// Загрузить список песен и альбомов исполнителя
        viewModel.input.loadDataForArtistID.accept(artist.artistId)
        
        
        /// Анимированно показать результат
        viewModel.output.cells.drive(onNext:{ _ in
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.tableView.alpha = 1
            })
        }).disposed(by: disposeBag)
        
        
        /// Заполнение tableView
        viewModel.output.cells.drive(tableView.rx.items) { [unowned self] tableView, row, cellType in
            switch cellType {
            case .albums(let list): return self.getAlbumsCell(with: list)
            case .song(let info): return self.getSongCell(with: info)
            }
        }.disposed(by: disposeBag)
        
    }
    
    
    /// Генерация ячейки для списка альбомов
    private func getAlbumsCell(with albumsList: [Album]) -> UITableViewCell {
        let cell = tableView.getCell(forClass: AlbumsCell.self)
        cell.setup(albums: albumsList)
        return cell
    }
    
    
    /// Генерация ячейки для песни
    private func getSongCell(with song: Song) -> UITableViewCell {
        let cell = tableView.getCell(forClass: SongCell.self)
        cell.setup(title: song.trackName, album: song.collectionName, artworkURL: song.artworkUrl100)
        return cell
    }
}

