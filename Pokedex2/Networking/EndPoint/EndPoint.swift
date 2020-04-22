//
//  EndPoint.swift
//  Pokedex
//
//  Created by Michele Mola on 03/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//

import Foundation

protocol Endpoint {
	var base: String { get }
	var path: String { get }
	var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
	var urlComponents: URLComponents {
		var components = URLComponents(string: base)!
		components.path = path
		components.queryItems = queryItems
		
		return components
	}
	
	var request: URLRequest {
		let url = urlComponents.url!
		return URLRequest(url: url)
	}
}
