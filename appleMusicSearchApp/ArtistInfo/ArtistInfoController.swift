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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = artist?.artistName
    }
}

