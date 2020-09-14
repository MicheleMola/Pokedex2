//
//  UIView+roundCorners.swift
//  Pokedex
//
//  Created by Michele Mola on 26/03/2020.
//  Copyright © 2020 Michele Mola. All rights reserved.
//

import UIKit

extension UIView {
	func roundCorners(
		corners: UIRectCorner,
		radius: CGFloat)
	{
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
}
