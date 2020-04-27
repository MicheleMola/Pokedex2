//
//  Box.swift
//  Pokedex2
//
//  Created by Michele Mola on 25/04/2020.
//

import Foundation

final class Box<T> {
	
	typealias Listener = (T) -> Void
	var listener: Listener?
	
	var value: T {
		didSet {
			listener?(value)
		}
	}
	
	init(_ value: T) {
		self.value = value
	}

	func bind(listener: Listener?) {
		self.listener = listener
		listener?(value)
	}
}

