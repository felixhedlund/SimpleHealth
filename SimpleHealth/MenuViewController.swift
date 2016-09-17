//
//  MenuViewController.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 13/09/2016.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit
import IBAnimatable
class MenuViewController: UIViewController {
    @IBOutlet weak var runningImage: AnimatableImageView!
    @IBOutlet weak var foodImage: AnimatableImageView!
    @IBOutlet weak var runningButton: AnimatableButton!
    @IBOutlet weak var foodButton: AnimatableButton!
    @IBOutlet weak var titleLabel: AnimatableLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func didPressRunningButton(_ sender: AnyObject) {
        removeDelays()
        let rect = runningImage.frame
        
        
        runningImage.moveBy(x: 0, y: Double(-rect.minY) + 24){
            self.runningButton.slideFade(.out, direction: .left, completion: nil)
            self.foodButton.slideFade(.out, direction: .left, completion: nil)
            self.foodImage.slideFade(.out, direction: .left, completion: nil)
            self.titleLabel.slideFade(.out, direction: .left, completion: nil)
            if let delegate = (UIApplication.shared.delegate as! AppDelegate).backgroundDelegate{
                delegate.animateWithColor(ColorTheme.yellowColor)
            }
        }
        
    }
    @IBAction func didPressFoodButton(_ sender: AnyObject) {
        removeDelays()
        let rect = foodImage.frame
        
        foodImage.moveBy(x: 0, y: Double(-rect.minY) + 24){
            self.runningButton.slideFade(.out, direction: .left, completion: nil)
            self.foodButton.slideFade(.out, direction: .left, completion: nil)
            self.runningImage.slideFade(.out, direction: .left, completion: nil)
            self.titleLabel.slideFade(.out, direction: .left, completion: nil)
            if let delegate = (UIApplication.shared.delegate as! AppDelegate).backgroundDelegate{
                delegate.animateWithColor(ColorTheme.greenColor)
            }
        }
    }
    
    fileprivate func removeDelays(){
        runningImage.delay = 0
        foodImage.delay = 0
        runningButton.delay = 0
        foodButton.delay = 0
        titleLabel.delay = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
