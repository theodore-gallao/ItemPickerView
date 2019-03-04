# ItemPickerView
Swipe horizontally or tap to select through segmented items. 

![Demo](https://github.com/theodore-gallao/ItemPickerView/blob/master/Demos/ItemPickerView_Demo.gif)
![Applied Demo](https://github.com/theodore-gallao/ItemPickerView/blob/master/Demos/ItemPickerView_Applied_Demo.gif)

## Prerequisites
Swift 4.2+, iOS 10+, CocoaPods

## Installation
Cocoapods
``` ruby
pod 'ItemPickerView', :git=> 'https://github.com/theodore-gallao/ItemPickerView.git'
```

## Usage
Import the framework
``` swift
import ItemPickerView
```

Create an ItemPickerView object
``` swift
var itemPickerView: ItemPickerView!

override func viewDidLoad() {
    super.viewDidLoad()
    
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

## Appearance
Change the appearance properties of `ItemPickerView` and `Item`.

### ItemPickerView
Appearance properties of `ItemPickerView`.

#### Gradient Width
The width of the left and right gradients, default `100`. Set to 0 to remove gradients.
``` swift
self.itemPickerView.gradientWidth = 100
```

#### Gradient Color
The color of the left and right gradients, default `UIColor.black`. Ideally, set this to the same value as itemPickerView.backgroundColor.
``` swift
self.itemPickerView.gradientColor = UIColor.black
```

### Item
Appearance properies of `Item`, default `""`

#### Text
The text of this item
``` swift
let item = Item()
item.text = ""
```

#### Font
The font of this item's text, default `UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)`
``` swift
let item = Item()
item.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
```
#### Color
The text color of this item, default `UIColor.gray`
``` swift
let item = Item()
item.color = UIColor.gray
```
#### Selected Color
The selected color of this item, default `Default UIColor.black`
``` swift
let item = Item()
item.selectedColor = Default UIColor.black
```

## Authors
Theodore Gallao - [GitHub](https://github.com/theodore-gallao)

## License
This project is under the MIT license. See [LICENSE.md](https://github.com/theodore-gallao/ItemPickerView/blob/master/LICENSE).
