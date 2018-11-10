# Slide Up Card Controller
## Purpose
see [Use Case 1](https://stackoverflow.com/questions/37967555/how-can-i-mimic-the-bottom-sheet-from-the-maps-app)

see [Use Case 2](https://www.raywenderlich.com/221-recreating-the-apple-music-now-playing-transition)

> Slide Up Card Controller aims to be a lightweight solution for the above use cases. For those that want a more robust solution [pulley](https://cocoapods.org/pods/Pulley) may be better suited to you

----
## Usage
1. Drag the Card folder into your project
2. Set up the Card View Controller on the desired view controller

----


```swift
class ViewController: UIViewController {

  // 1. Set instance var for the card controller
  var cardViewController: CardViewController!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // 2. Set up card after the parent VC has been layed out
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
```
----
## Preview

![preview](https://user-images.githubusercontent.com/6512820/48295749-98102b00-e4da-11e8-9293-b34df1f434c0.gif)


----
## Enjoy

