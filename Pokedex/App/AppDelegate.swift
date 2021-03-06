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
		let pokemonListViewController = PokemonListViewController()
		let masterNavigationController = UINavigationController(rootViewController: pokemonListViewController)
		
		let pokemonDetailViewController = PokemonDetailViewController()
		
		let splitViewController = UISplitViewController()
		splitViewController.viewControllers = [masterNavigationController, pokemonDetailViewController]
		splitViewController.preferredDisplayMode = .allVisible
		splitViewController.delegate = self
		
		let window = UIWindow()
		window.rootViewController = splitViewController
		self.window = window
		window.makeKeyAndVisible()
		
		return true
	}
}

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
}

