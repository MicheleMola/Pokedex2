//
//  AppDelegate.swift
//  Pokedex2.0
//
//  Created by Michele Mola on 21/04/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		let pokemonListViewController = PokemonListViewController()
		let navController = UINavigationController(rootViewController: pokemonListViewController)
        
        let w = UIWindow()
        w.rootViewController = navController
        self.window = w
        w.makeKeyAndVisible()
		
		return true
	}
}

