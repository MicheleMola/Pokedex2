//
//  StatIndicatorView.swift
//  Pokedex
//
//  Created by Michele Mola on 27/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

class StatIndicatorView: UIView {
	let valueLabel = UILabel()
	let progressView = UIProgressView()
	
	// Max value for stats
	let maxValue = 252
	
	var progressValue: Int? {
		didSet {
			self.update()
		}
	}
	
	var progressBackgroundColor: UIColor? {
		didSet {
			self.progressView.progressTintColor = self.progressBackgroundColor
		}
	}
	
	var trackColor: UIColor? {
		didSet {
			self.progressView.trackTintColor = self.trackColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setup()
		self.style()
		self.layout()
	}
	
	private func setup() {
		self.addSubview(self.valueLabel)
		self.addSubview(self.progressView)
	}
	
	private func style() {
		self.valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
	}
	
	private func update() {
		guard let progressValue = self.progressValue else { return }
		
		let percentageValue = Float(progressValue) / Float(self.maxValue)
		
		self.progressView.progress = percentageValue
		
		self.valueLabel.text = "\(progressValue)"
	}
	
	private func layout() {
		
		self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
		let valueLabelConstraints = [
			self.valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.valueLabel.widthAnchor.constraint(equalToConstant: 36)
		]
		NSLayoutConstraint.activate(valueLabelConstraints)
		
		self.progressView.translatesAutoresizingMaskIntoConstraints = false
		let progressViewConstraints = [
			self.progressView.leadingAnchor.constraint(equalTo: self.valueLabel.trailingAnchor, constant: 16),
			self.progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			self.progressView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
		]
		NSLayoutConstraint.activate(progressViewConstraints)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Add corner radius to Progress and Track part
		self.progressView.subviews.forEach { subview in
			subview.layer.masksToBounds = true
			subview.layer.cornerRadius = (self.bounds.height * 0.3) / 2
		}
	}
}
