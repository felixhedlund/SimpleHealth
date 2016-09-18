//
//  ContentCollectionViewCell.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 18/09/16.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit
import IBAnimatable
class ContentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var triangleView: AnimatableView!
    @IBOutlet weak var circleView: AnimatableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func setupCell(name: String?){
        if let title = name{
            titleLabel.text = title
        }else{
            titleLabel.text = ""
        }
        setRandomColor()
    }
    
    fileprivate func setRandomColor(){
        let randomInt = Int(arc4random_uniform(5))
        switch randomInt{
        case 0:
            triangleView.backgroundColor = ColorTheme.redColor
        case 1:
            triangleView.backgroundColor = ColorTheme.blueColor
        case 2:
            triangleView.backgroundColor = ColorTheme.greenColor
        case 3:
            triangleView.backgroundColor = ColorTheme.yellowColor
        case 4:
            triangleView.backgroundColor = ColorTheme.orangeColor
        default:
            triangleView.backgroundColor = UIColor.black
        }
    }
}
