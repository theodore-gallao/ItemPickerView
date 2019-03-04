# ItemPickerView
Swipe horizontally to select through segmented items. 

![Demo](https://github.com/theodore-gallao/ItemPickerView/blob/master/Demos/ItemPickerView_Demo.gif)
![Applied Demo](https://github.com/theodore-gallao/ItemPickerView/blob/master/Demos/ItemPickerView_Applied_Demo.gif)

## Prerequisites
Swift 4.2+, iOS 10+, CocoaPods

## Installation
Cocoapods
`pod 'ItemPickerView', :git=> 'https://github.com/theodore-gallao/ItemPickerView.git'`

## Usage
Import the framework
``` swift
import ItemPickerView
```

Create an ItemPickerView object
``` swift
var itemPickerView: ItemPickerView!

override func viewDidLoad() {
    self.itemPickerView = ItemPickerView()
}
```

Set properties
``` swift
override func viewDidLoad() {
    // ...
    
    self.itemPickerView.backgroundColor = UIColor.black
    self.itemPickerView.gradientColor = UIColor.black
    self.itemPickerView.gradientWidth = 75
    self.itemPickerView.translatesAutoresizingMaskIntoConstraints = false
}
```

Set delegate and data source. Be sure that they conform to the protocols `ItemPickerViewDelegate` and `ItemPickerViewDataSource`
``` swift 
override func viewDidLoad() {
    // ...
    
    self.itemPickerView.delegate = self
    self.itemPickerView.dataSource = self
} 
```

Layout the ItemPickerView
``` swift
override func viewDidLoad() {
    // ...
    
    self.view.addSubview(self.itemPickerView)
    self.itemPickerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    self.itemPickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    self.itemPickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    self.itemPickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
} 
```
Set the items
``` swift
var items: [Item]!

override func viewDidLoad() {
    // ...
    
    let item = Item(text: "Item", selectedColor: UIColor.yellow)
    let anotherItem = Item(text: "Another Item", font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold), color: UIColor.cyan.withAlphaComponent(0.7), selectedColor: UIColor.cyan)
    let lastItem = Item(text: "Last Item", color: UIColor.orange.withAlphaComponent(0.7), selectedColor: UIColor.orange)
    self.items = [item, anotherItem, lastItem]
} 
```

Implement the data source functions, and handle the delegate functions(optional). Be sure that they conform to the protocols `ItemPickerViewDelegate` and `ItemPickerViewDataSource`
``` swift
// Return number of items
func itemPickerViewNumberOfItems(_ itemPickerView: ItemPickerView) -> Int {
    return self.items.count
}

// Return Item at index
func itemPickerView(_ itemPickerView: ItemPickerView, itemAtIndex index: Int) -> Item {
    return self.items[index]
}

// Called when item is selected
func itemPickerView(_ itemPickerView: ItemPickerView, didSelectItemAtIndex index: Int) {
    // Handle item selection at given index.
}
```
## Authors
**Theodore Gallao**

## License
This project is under the MIT license. See [LICENSE.md](LICENSE.md) file for details
