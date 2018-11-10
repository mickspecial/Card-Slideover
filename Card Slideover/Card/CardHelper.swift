//
//  CardHelper.swift
//  fd
//
//  Created by Michael Schembri on 10/11/18.
//  Copyright © 2018 Michael Schembri. All rights reserved.
//

import UIKit

enum CardCurrentState: String {
	case cardWillOpen, cardWillClose, cardDidClose, cardDidOpen
}

class CardHelper {
	
	enum CardState {
		case expanded
		case collapsed
	}
	
	private (set) var cardCallback: CardCurrentState! {
		didSet {
			let notification = Notification(name: .cardStateNotification)
			NotificationQueue.default.enqueue(notification, postingStyle: .now)
		}
	}
	weak var cardVC: CardViewController?
	private (set) var cardVisible = false
	private var runningAnimations = [UIViewPropertyAnimator]()
	private var animationProgressWhenInterrupted: CGFloat = 0
	private var percentageShownWhenExpanded: CGFloat

	private var nextState: CardState {
		return cardVisible ? .collapsed : .expanded
	}
	
	init(for cardViewController: CardViewController, percentageShownWhenExpanded: CGFloat) {
		cardVC = cardViewController
		self.percentageShownWhenExpanded = percentageShownWhenExpanded
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardHelper.handleCardTap(recognzier:)))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CardHelper.handleCardPan(recognizer:)))
		cardVC!.customView.cardHandle.addGestureRecognizer(tapGestureRecognizer)
		cardVC!.customView.cardHandle.addGestureRecognizer(panGestureRecognizer)
	}
	
	// MARK: - Gesture Recognizers

	@objc func handleCardTap(recognzier: UITapGestureRecognizer) {
		switch recognzier.state {
		case .ended:
			animateTransitionIfNeeded(state: nextState, duration: 0.9)
		default:
			break
		}
	}
	
	@objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			startInteractiveTransition(state: nextState, duration: 0.9)
		case .changed:
			let translation = recognizer.translation(in: self.cardVC!.customView.cardHandle)
			var fractionComplete = translation.y / cardVC!.cardHeight
			fractionComplete = cardVisible ? fractionComplete : -fractionComplete
			updateInteractiveTransition(fractionCompleted: fractionComplete)
		case .ended:
			continueInteractiveTransition()
		default:
			break
		}
	}
	
	// MARK: - Animation of Card

	func animateTransitionIfNeeded (state: CardState, duration: TimeInterval) {
		
		if runningAnimations.isEmpty {
			// on setup the card size equals the size of the superview it is added to
			// adjust this to set expanded size to be shown //
			let calculatedAmountofCardToBeShown = self.cardVC!.cardHeight * percentageShownWhenExpanded
			let parentControllerViewHeight = self.cardVC!.parentVC!.view.frame.height
			
			cardCallback = cardVisible ? .cardWillClose : .cardWillOpen
			
			// spring like animation
			let parameters = UISpringTimingParameters.init(dampingRatio: 0.63, frequencyResponse: 0.39)
			let frameAnimator = UIViewPropertyAnimator(duration: 0, timingParameters: parameters)
			
			frameAnimator.addAnimations {
				// completed animation state
				switch state {
				case .expanded:
					self.cardVC!.view.frame.origin.y = parentControllerViewHeight - calculatedAmountofCardToBeShown
				case .collapsed:
					self.cardVC!.view.frame.origin.y = parentControllerViewHeight - CardSettingsView.cardHandleHeight
				}
			}
			
			frameAnimator.addCompletion { _ in
				// toggle current state
				self.cardVisible = !self.cardVisible
				// send callbacks
				self.cardCallback = self.cardVisible ? .cardDidOpen : .cardDidClose
				// clean out animations
				self.runningAnimations.removeAll()
			}
			
			frameAnimator.startAnimation()
			runningAnimations.append(frameAnimator)
		}
	}
	
	func startInteractiveTransition(state: CardState, duration: TimeInterval) {
		if runningAnimations.isEmpty {
			animateTransitionIfNeeded(state: state, duration: duration)
		}
		for animator in runningAnimations {
			animator.pauseAnimation()
			animationProgressWhenInterrupted = animator.fractionComplete
		}
	}
	
	func updateInteractiveTransition(fractionCompleted: CGFloat) {
		for animator in runningAnimations {
			animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
		}
	}
	
	func continueInteractiveTransition () {
		for animator in runningAnimations {
			animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		}
	}
}

// MARK: - Spring Animation

extension UISpringTimingParameters {
	// https://medium.com/ios-os-x-development/demystifying-uikit-spring-animations-2bb868446773
	// https://github.com/jenox/UIKit-Playground
	
	convenience init(dampingRatio: CGFloat, frequencyResponse: CGFloat) {
		precondition(dampingRatio >= 0)
		precondition(frequencyResponse > 0)
		
		let mass = 1 as CGFloat
		let stiffness = pow(2 * .pi / frequencyResponse, 2) * mass
		let damping = 4 * .pi * dampingRatio * mass / frequencyResponse
		
		self.init(mass: mass, stiffness: stiffness, damping: damping, initialVelocity: .zero)
	}
}


// MARK: - Notification For Card State Changes

extension Notification.Name {
	static let cardStateNotification = Notification.Name("cardStateDidChange")
}

@objc protocol CardStateNotification {
	@objc func cardStateDidChange()
}

extension CardStateNotification {
	func registerForCardStateChanges() {
		NotificationCenter.default.addObserver(self, selector: #selector(cardStateDidChange), name: .cardStateNotification, object: nil)
	}
}

