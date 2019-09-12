//
//  AppDelegate.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 12/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let artistSearchController = ArtistSearchController()
        let navController = UINavigationController(rootViewController: artistSearchController)
        navController.navigationBar.prefersLargeTitles = true
        artistSearchController.title = "Поиск исполнителя"
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        return true
    }
}
