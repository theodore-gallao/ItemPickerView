//
//  LabelCollectionViewCell.swift
//  Foodbase
//
//  Created by Theodore Gallao on 2/10/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import UIKit

internal class ItemCollectionViewCell: UICollectionViewCell {
    static let id = "__ITEM_COLLECTION_VIEW_CELL_ID__"
    
    var labelBackgroundColor: UIColor = UIColor.clear {
        didSet {
            self.label.backgroundColor = self.labelBackgroundColor
        }
    }
    
    var text: String = "" {
        didSet {
            self.label.text = self.text
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular) {
        didSet {
            self.label.font = self.font
        }
    }
    
    var textAlignment: NSTextAlignment = NSTextAlignment.center {
        didSet {
            self.label.textAlignment = self.textAlignment
        }
    }
    
    var textColor: UIColor = UIColor.black {
        didSet {
            self.label.textColor = self.textColor
        }
    }
    
    var selectedTextColor: UIColor = UIColor.blue
    
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.contentView.addSubview(self.label)
        
        self.configureConstraints()
    }
}

extension ItemCollectionViewCell {
    private func configureConstraints() {
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
    }
}
