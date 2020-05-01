//
//  CombineImageLoader.swift
//  Pokedex2
//
//  Created by Michele Mola on 01/05/2020.
//

import UIKit
import Combine

let cache = NSCache<NSURL, UIImage>()

struct CombineImageLoader {
	static func load(from url: URL) -> AnyPublisher<UIImage?, Never> {
		if let image = cache.object(forKey: url as NSURL) {
			return Just(image)
				.eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { UIImage(data: $0.data) }
			.replaceError(with: nil)
			.handleEvents(receiveOutput: { image in
				guard let image = image else { return }
				cache.setObject(image, forKey: url as NSURL)
			})
			.eraseToAnyPublisher()
	}
}
