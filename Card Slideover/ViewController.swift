//
//  ViewController.swift
//  fd
//
//  Created by Michael Schembri on 9/11/18.
//  Copyright © 2018 Michael Schembri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// 1. Set instance var for the card controller
	var cardViewController: CardViewController!
	
	private var	helloLabel: UILabel = {
		let label = UILabel(frame: .init(origin: .zero, size: .init(width: 200, height: 80)))
		label.textColor = .darkText
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
		label.text = "Hello 🥳"
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(helloLabel)
		helloLabel.center = view.center
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// 2. Set up card after the parent VC has be layed out
		if cardViewController == nil {
			cardViewController = CardViewController()
			cardViewController.place(on: self, percentageShownWhenExpanded: 0.7)
			// 3. Optional - extend the class with CardStateNotification protocol
			registerForCardStateChanges()
		}
	}
}

extension ViewController: CardStateNotification {
	// allows the parent to access / respond to card state changes
	func cardStateDidChange() {
		print(cardViewController.currentCardState.rawValue)
	}	
}
