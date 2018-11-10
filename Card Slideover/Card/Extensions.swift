//
//  Helpers.swift
//  fd
//
//  Created by Michael Schembri on 9/11/18.
//  Copyright © 2018 Michael Schembri. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func add(_ child: UIViewController, frame: CGRect? = nil) {
		addChild(child)
		
		if let frame = frame {
			child.view.frame = frame
		}
		
		view.addSubview(child.view)
		child.didMove(toParent: self)
	}
	
	func remove() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
