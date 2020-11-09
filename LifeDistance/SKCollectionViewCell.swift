//
//  SKCollectionViewCell.swift
//  LifeDistance
//
//  Created by Marino Schmid on 08.11.20.
//

import UIKit
import SpriteKit

class SKCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var skview: SKView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    @IBOutlet weak var textLabel: UILabel!
}
