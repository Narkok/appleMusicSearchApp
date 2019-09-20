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
        setupView()
        
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        viewModel.output.artists.drive(tableView.rx.items) { tableView, row, artist in
            let cell = UITableViewCell()
            cell.textLabel?.text = artist.artistName
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    private func setupView() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
    }
}

