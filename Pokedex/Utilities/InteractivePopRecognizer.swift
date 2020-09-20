//
//  InteractivePopRecognizer.swift
//  Pokedex
//
//  Created by Michele Mola on 20/09/20.
//

import UIKit

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		self.navigationController.viewControllers.count > 1
	}
	
	func gestureRecognizer(
		_ gestureRecognizer: UIGestureRecognizer,
		shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
	) -> Bool {
		true
	}
}
