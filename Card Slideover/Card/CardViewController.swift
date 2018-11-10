//
//  CardVC.swift
//  fd
//
//  Created by Michael Schembri on 9/11/18.
//  Copyright © 2018 Michael Schembri. All rights reserved.
//

import UIKit

// MARK: - Card View Controller

class CardViewController: UIViewController {
	
	let customView = CardSettingsView()
	private (set) weak var parentVC: UIViewController?
	private var cardHelper: CardHelper!
	
	var cardHeight: CGFloat {
		return UIScreen.main.bounds.height
	}
	
	var isCardVisible: Bool {
		return cardHelper.cardVisible
	}
	
	var currentCardState: CardCurrentState {
		return cardHelper.cardCallback
	}
	
	override func loadView() {
		self.view = customView
	}

	func place(on parentVC: UIViewController, percentageShownWhenExpanded showPercentage: CGFloat = 0.75) {
		self.parentVC = parentVC
		parentVC.add(self)
		view.frame = CGRect(x: 0, y: parentVC.view.frame.height - CardSettingsView.cardHandleHeight, width: parentVC.view.bounds.width, height: cardHeight)
		cardHelper = CardHelper(for: self, percentageShownWhenExpanded: showPercentage)
	}
}

// MARK: - Card View

class CardSettingsView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	static let cardHandleHeight: CGFloat = 65
	
	private (set) var cardHandle: UIView = {
		// the top part of the card that will respond to touches to initiate opening and closing the card
		let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: CardSettingsView.cardHandleHeight))
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var smallPillIcon: UIView = {
		let height: CGFloat = 4
		let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: height))
		view.backgroundColor = .white
		view.alpha = 0.5
		view.layer.cornerRadius = height / 2
		view.layer.masksToBounds = false
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private (set) var visualEffect: UIVisualEffectView = {
		let visualEffectView = UIVisualEffectView()
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		// allows touches to pass through
		// needed for when control to the card view
		visualEffectView.isUserInteractionEnabled = false
		visualEffectView.effect = UIBlurEffect(style: .dark)
		return visualEffectView
	}()
	
	private func setupView() {
		
		addShadow()
		addSubview(visualEffect)
		addSubview(cardHandle)
		cardHandle.addSubview(smallPillIcon)
		
		// MARK: - Add Your Custom Controls Here
		// UISlider / UITextField etc

		NSLayoutConstraint.activate([
			// grab area
			cardHandle.topAnchor.constraint(equalTo: topAnchor),
			cardHandle.leadingAnchor.constraint(equalTo: leadingAnchor),
			cardHandle.trailingAnchor.constraint(equalTo: trailingAnchor),
			cardHandle.heightAnchor.constraint(equalToConstant: CardSettingsView.cardHandleHeight),
			// effects view
			visualEffect.topAnchor.constraint(equalTo: topAnchor),
			visualEffect.bottomAnchor.constraint(equalTo: bottomAnchor),
			visualEffect.leadingAnchor.constraint(equalTo: leadingAnchor),
			visualEffect.trailingAnchor.constraint(equalTo: trailingAnchor),
			// pill icon
			smallPillIcon.topAnchor.constraint(equalTo: cardHandle.topAnchor, constant: 8),
			smallPillIcon.widthAnchor.constraint(equalToConstant: 40),
			smallPillIcon.heightAnchor.constraint(equalToConstant: 4),
			smallPillIcon.centerXAnchor.constraint(equalTo: cardHandle.centerXAnchor)
			// your custom constraints go here...
		])
	}
	
	private func addShadow() {
		// for shadow - but no corners
		layer.masksToBounds = false
		layer.shadowColor = UIColor.darkGray.cgColor
		layer.shadowOpacity = 0.4
		layer.shadowOffset = CGSize(width: 0, height: -2)
		layer.shadowRadius = 3
	}
}
