//
//  UIViewController+showAlert.swift
//  Pokedex
//
//  Created by Michele Mola on 28/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

extension UIViewController {
	func showAlert(
		withTitle title: String,
		andMessage message: String
	) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let closeAction = UIAlertAction(title: "Close", style: .cancel) { action in
			self.navigationController?.popViewController(animated: true)
		}
		
		closeAction.setValue(UIColor.black, forKey: "titleTextColor")
		alertController.addAction(closeAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
}
