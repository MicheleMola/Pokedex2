//
//  Device.swift
//  Pokedex
//
//  Created by Michele Mola on 18/09/20.
//

import UIKit

struct Device {	
	static var isIpad: Bool {
		UIDevice.current.userInterfaceIdiom == .pad
	}
}
