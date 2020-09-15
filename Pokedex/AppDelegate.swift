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
		
		let pokemonListViewController = PokemonListViewController(viewModel: nil)
		let navController = UINavigationController(rootViewController: pokemonListViewController)
		
		let pokemonDetailViewController = PokemonDetailViewController(viewModel: nil)
//		let detailNavController = UINavigationController(rootViewController: pokemonDetailViewController)
		
		let splitViewController = UISplitViewController()
		splitViewController.viewControllers = [navController, pokemonDetailViewController]
		splitViewController.preferredDisplayMode = .allVisible
		splitViewController.delegate = self
		
		let w = UIWindow()
		w.rootViewController = splitViewController
		self.window = w
		w.makeKeyAndVisible()
		
		return true
	}
}

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
}

