//
//  ArtistSearchController.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 12/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistSearchController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ArtistSearchViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Настройка навбара
        navigationItem.title = "Search artist"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        
        /// Введенная в поиск строка
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        
        /// Заполнение таблицы
        viewModel.output.artists.drive(tableView.rx.items) { tableView, row, artist in
            let cell = tableView.getCell(forClass: ArtistCell.self)
            cell.nameLabel.text = artist.artistName
            cell.genreLabel.text = artist.primaryGenreName
            return cell
        }.disposed(by: disposeBag)
        
        
        /// Переход на экран исполнителя
        tableView.rx.modelSelected(Artist.self)
            .subscribe(onNext:{ [weak self] artist in
                guard let self = self else { return }
                let artistInfoController = ArtistInfoController()
                artistInfoController.artist = artist
                self.navigationController?.pushViewController(artistInfoController, animated: true)
            }).disposed(by: disposeBag)
        
    }
}

