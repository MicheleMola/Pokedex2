//
//  Array+subscript.swift
//  Pokedex
//
//  Created by Michele Mola on 28/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import Foundation

extension Array {
	public subscript(safeIndex index: Int) -> Element? {
		guard index >= 0, index < endIndex else {
			return nil
		}
		
		return self[index]
	}
}
