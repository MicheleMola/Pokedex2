//
//  PokeBallLoader.swift
//  Pokedex
//
//  Created by Michele Mola on 26/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

class PokeBallLoader: UIView {
	let pokeBallImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup

	private func setup() {
		self.addSubview(self.pokeBallImageView)
		
		self.isUserInteractionEnabled = false
	}
	
	// MARK: - Style

	private func style() {		
		self.pokeBallImageView.image = UIImage(named: "pokeball")
		self.pokeBallImageView.contentMode = .scaleAspectFit
		self.pokeBallImageView.alpha = 0
	}
	
	// MARK: - Layout

	private func layout() {
		self.pokeBallImageView.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			self.pokeBallImageView.topAnchor.constraint(equalTo: self.topAnchor),
			self.pokeBallImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
			self.pokeBallImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			self.pokeBallImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
			self.pokeBallImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.pokeBallImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	func show() {
		self.pokeBallImageView.alpha = 1
		
		UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
			self.pokeBallImageView.transform = CGAffineTransform(rotationAngle: -45)
			self.pokeBallImageView.transform = CGAffineTransform(rotationAngle: 45)
		}, completion: nil)
	}
	
	func dismiss() {
		self.pokeBallImageView.alpha = 0
		self.pokeBallImageView.transform = .identity
	}
}
