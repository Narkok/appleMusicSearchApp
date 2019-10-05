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
        
        
        /// Обнуление offset, если строка была изменена
        searchController.searchBar.rx.text
            .map { _ in 0 }
            .bind(to: viewModel.input.offset)
            .disposed(by: disposeBag)
        
        
        /// Заполнение таблицы
        viewModel.output.artists.drive(tableView.rx.items) { tableView, row, artist in
            let cell = tableView.getCell(forClass: ArtistCell.self)
            cell.setup(name: artist.artistName, genre: artist.primaryGenreName)
            return cell
        }.disposed(by: disposeBag)
        
        
        /// Переход на экран исполнителя
        tableView.rx.modelSelected(Artist.self)
            .subscribe(onNext:{ [unowned self] artist in
                let artistInfoController = ArtistInfoController()
                artistInfoController.artist = artist
                self.navigationController?.pushViewController(artistInfoController, animated: true)
            }).disposed(by: disposeBag)
        
        
        /// Достижение конца списка
        tableView.rx.willDisplayCell
            .filter { [unowned self] cell -> Bool in
                return cell.indexPath.row == self.tableView.numberOfRows(inSection: 0) - 1
            }
            .map { $0.indexPath.row + 1 }
            .distinctUntilChanged()
            .bind(to: viewModel.input.offset)
            .disposed(by: disposeBag)
        
        
    }
}

