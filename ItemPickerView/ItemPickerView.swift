//
//  ItemPickerView.swift
//  Foodbase
//
//  Created by Theodore Gallao on 3/1/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import UIKit

// MARK: String Extension
internal extension String {
    /// Calculating width of a label containins the string given heigh and font.
    func width(heightConstraint height: CGFloat, font: UIFont) -> CGFloat {
        let rect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let bounds = self.boundingRect(with: rect, options: .usesLineFragmentOrigin,
                                       attributes: [NSAttributedString.Key.font: font],
                                       context: nil)
        return ceil(bounds.width)
    }
}

// MARK: Item Picker View Delegate - Interface
/// The delegate protocol for `ItemPickerView`. Implement the protocol methods to handle events called by the `ItemPickerView` instance.
public protocol ItemPickerViewDelegate {
    /// Called when an item has been selected, giving the `ItemPickerView` instance and the index of the selected item.
    func itemPickerView(_ itemPickerView: ItemPickerView, didSelectItemAtIndex index: Int)
}

// MARK: Item Picker View Delegate - Default/Optional Methods
public extension ItemPickerViewDelegate {
    func itemPickerView(_ itemPickerView: ItemPickerView, didSelectItemAtIndex index: Int) {
        // This protocol method is optional.
    }
}

// MARK: Item Picker View Data Source - Interface
/// The data source protocol for `ItemPickerView`. Implement the protocol methods to supply the necessary data for the `ItemPickerView` when called.
public protocol ItemPickerViewDataSource {
    /// Called when required to return the number of items the ItemPickerView contains.
    func itemPickerViewNumberOfItems(_ itemPickerView: ItemPickerView) -> Int
    
    /// Called when required to return the item given the `ItemPickerView` instance and the index.
    func itemPickerView(_ itemPickerView: ItemPickerView, itemAtIndex index: Int) -> Item
}

// MARK: Item Struct
/// Represents an item used for `ItemPickerView`
public struct Item {
    /// The text of this item
    public var text: String
    
    /// The font of this item's text
    public var font: UIFont
    
    /// The text color of this item
    public var color: UIColor
    
    /// The selected color of this item
    public var selectedColor: UIColor
    
    public init(text: String = "",
                font: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold),
                color: UIColor = UIColor.gray,
                selectedColor: UIColor = UIColor.black)
    {
        self.text = text
        self.font = font
        self.color = color
        self.selectedColor = selectedColor
    }
}

// MARK: Item Picker View - Variabless & Initializers
/// Used to select through segmented items, swiping horizontally.
public class ItemPickerView: UIView {
    /// The delegate for `ItemPickerView`. Set delegate and to handle events.
    public var delegate: ItemPickerViewDelegate?
    
    /// The data source for `ItemPickerView`. Set the data source to supply data for display.
    public var dataSource: ItemPickerViewDataSource?
    
    /// The index for the item that is currently selected. This is a get-only property.
    public private(set) var indexForSelectedItem: Int = 0
    
    /// The number of items in this `ItemPickerView`. This is a get-only property.
    public private(set) var numberOfItems: Int = 0
    
    /// A dictionary of items keyed by their respective indices. This is a get-only property.
    public private(set) var items = [Int: Item]()
    
    public var isIndicatorHidden: Bool = false {
        didSet {
            self.indicatorView.alpha = self.isIndicatorHidden ? 0 : 1
        }
    }
    
    public var indicatorColor: UIColor = UIColor.black {
        didSet {
            self.indicatorView.backgroundColor = self.indicatorColor
        }
    }
    
    public var indicatorHeight: CGFloat = 3.5 {
        didSet {
            UIView.animate(withDuration: 1/3) {
                self.configureLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    /// Sets the width of the left and right gradients. Set to 0 to remove the gradients.
    public var gradientWidth: CGFloat = 100 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    /// Sets the color of the left and right gradients.
    public var gradientColor: UIColor = UIColor.black {
        didSet {
            let gradientColors = [self.gradientColor.cgColor, self.gradientColor.withAlphaComponent(0).cgColor]
            
            self.leftGradientLayer.colors = gradientColors
            self.rightGradientLayer.colors = gradientColors
        }
    }
    
    private var selectedCellWidth: CGFloat  = 0
    
    private var firstCellWidth: CGFloat {
        if let itemItem = self.items[0] {
            let width = itemItem.text.width(heightConstraint: self.collectionView.frame.height, font: itemItem.font)
            
            return width
        } else {
            return 0
        }
    }
    
    private var lastCellWidth: CGFloat {
        if let itemItem = self.items[self.numberOfItems - 1] {
            let width = itemItem.text.width(heightConstraint: self.collectionView.frame.height, font: itemItem.font)
            
            return width
        } else {
            return 0
        }
    }
    
    private var didSwipe = false // This is used as a flag. If true when called, call delegate protocol didSelectItem
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        
        return collectionView
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumInteritemSpacing = 20
        collectionViewFlowLayout.minimumLineSpacing = 0
        
        return collectionViewFlowLayout
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let leftGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        return gradientLayer
    }()
    
    private let rightGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        
        return gradientLayer
    }()
    
    private let panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer()
        
        return panGestureRecognizer
    }()
    
    private var indicatorViewConstraints = [NSLayoutConstraint]()
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.addSubview(self.collectionView)
        self.addSubview(self.indicatorView)
        
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        self.configureLayout()
        
        self.layer.addSublayer(self.leftGradientLayer)
        self.layer.addSublayer(self.rightGradientLayer)
        
        self.addGestureRecognizer(self.panGestureRecognizer)
        
        self.panGestureRecognizer.addTarget(self, action: #selector(self.handlePanGestureRecognizer(_:)))
    }
    
    private func configureLayout() {
        NSLayoutConstraint.deactivate(self.indicatorViewConstraints)
        
        self.indicatorViewConstraints = [
            self.indicatorView.heightAnchor.constraint(equalToConstant: self.indicatorHeight),
            self.indicatorView.widthAnchor.constraint(equalToConstant: self.selectedCellWidth),
            self.indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.indicatorViewConstraints)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
            
        self.leftGradientLayer.frame = CGRect(x: self.collectionView.frame.origin.x,
                                              y: self.collectionView.frame.origin.y,
                                              width: self.gradientWidth,
                                              height: self.collectionView.frame.height)
        
        self.rightGradientLayer.frame = CGRect(x: self.collectionView.frame.origin.x + self.collectionView.frame.width - self.gradientWidth,
                                               y: self.collectionView.frame.origin.y,
                                               width: self.gradientWidth,
                                               height: self.collectionView.frame.height)
    }
    
    
    @objc private func handlePanGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        let xTranslation = sender.translation(in: self).x
        let index = self.indexForSelectedItem
        
        if sender.state == .cancelled {
            sender.setTranslation(CGPoint.zero, in: self)
            sender.isEnabled = true
            
            return
        }
        
        if index == 0 {
            if xTranslation < -40 {
                sender.isEnabled = false
                self.didSwipe = true
                self.selectItem(at: index + 1, animated: true)
            }
        } else if index == self.numberOfItems - 1 {
            if xTranslation > 40 {
                sender.isEnabled = false
                self.didSwipe = true
                self.selectItem(at: index - 1, animated: true)
            }
        } else {
            if xTranslation < -40 {
                sender.isEnabled = false
                self.didSwipe = true
                self.selectItem(at: index + 1, animated: true)
            } else if xTranslation > 40 {
                sender.isEnabled = false
                self.didSwipe = true
                self.selectItem(at: index - 1, animated: true)
            }
        }
    }
    
    public func invalidateLayout() {
        self.collectionViewFlowLayout.invalidateLayout()
        self.collectionView.reloadData()
        
        self.collectionView.scrollToItem(at: IndexPath(item: self.indexForSelectedItem, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
}

// MARK: Item Picker View - Collection View
extension ItemPickerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = self.dataSource?.itemPickerViewNumberOfItems(self) ?? 0
        
        self.numberOfItems = numberOfItems
        
        return numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id, for: indexPath) as! ItemCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let item = self.items[indexPath.item] ?? Item()
        
        cell.labelBackgroundColor = UIColor.clear
        cell.text = item.text
        cell.font = item.font
        cell.textAlignment = NSTextAlignment.center
        cell.textColor = indexPath.item == self.indexForSelectedItem ? item.selectedColor : item.color
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.dataSource?.itemPickerView(self, itemAtIndex: indexPath.item) ?? Item()
        let text = item.text
        let width = text.width(heightConstraint: collectionView.frame.height, font: item.font)
        
        if indexPath.item == self.indexForSelectedItem {
            self.selectedCellWidth = width
            
            UIView.animate(withDuration: 1/3) {
                self.configureLayout()
                self.layoutIfNeeded()
            }
        }
        
        self.items[indexPath.item] = item
        
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemPickerView(self, didSelectItemAtIndex: indexPath.item)
        
        self.selectItem(at: indexPath.item, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != self.indexForSelectedItem
    }
    
    // Centers collection view cells
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftInset = (collectionView.frame.width / 2) - (self.firstCellWidth / 2)
        let rightInset = (collectionView.frame.width / 2) - (self.lastCellWidth / 2)
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

// MARK: Item Picker View - Member Functions
extension ItemPickerView {
    /// Selects the item at the given index with or without animation.
    public func selectItem(at index: Int, animated: Bool) {
        if index < 0 || index >= self.numberOfItems {
            return
        }
        
        if self.didSwipe {
            self.delegate?.itemPickerView(self, didSelectItemAtIndex: index)
        }
        
        self.didSwipe = false
        
        if animated {
            _ = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light).impactOccurred()
            
                self.collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                               animated: true,
                                               scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            
        } else {
            self.collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                           animated: false,
                                           scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        }
        
        self.indexForSelectedItem = index
        self.collectionView.reloadData()
    }
}
