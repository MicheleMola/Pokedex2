//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Michele Mola on 03/04/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

fileprivate let cache = NSCache<NSURL, UIImage>()

class AsyncLoadImageView: UIImageView {
	private var runningTask: URLSessionDataTask?
		
	func loadImage(at url: URL, withPlaceholderImage placeholderImage: UIImage? = nil, animated: Bool = false) {
		if let placeholderImage = placeholderImage {
			self.setImage(placeholderImage, animated: false)
		}
		
		if let image = cache.object(forKey: url as NSURL) {
			self.setImage(image, animated: animated)
			return
		}
		
		self.runningTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self else { return }
			
			if let data = data, let image = UIImage(data: data) {
				cache.setObject(image, forKey: url as NSURL)
				self.setImage(image, animated: animated)
			}
		}
		self.runningTask?.resume()
	}
	
	func cancelLoad() {
		self.runningTask?.cancel()
		self.runningTask = nil
	}
	
	private func setImage(_ image: UIImage, animated: Bool) {
		DispatchQueue.main.async {
			if animated {
				UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
					self.image = image
				}, completion: nil)
			} else {
				self.image = image
			}
		}
	}
}
