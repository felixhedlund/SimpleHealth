//
//  BackgroundViewController.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 12/09/2016.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit
import IBAnimatable

protocol BackgroundViewColorChangeDelegate{
    func animateWithColor(color: UIColor)
}

class BackgroundViewController: UIViewController, BackgroundViewColorChangeDelegate {
    @IBOutlet var triangles: [AnimatableView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateWithColor(color: UIColor){
        UIView.animateWithDuration(1.0, delay: 0.0, options:[UIViewAnimationOptions.CurveEaseIn], animations: {
            for triangle in self.triangles{
                triangle.fillColor = color
            }
            }, completion:nil)
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
