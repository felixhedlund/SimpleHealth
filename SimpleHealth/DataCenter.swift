//
//  DataCenter.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 18/09/16.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import Foundation
import Sync
import DATAStack

class DataCenter: NSObject{
    let dataStack = DATAStack(modelName: "SimpleHealth")
    
    let jsonFileNames = (exersizes: "exercisesStatic", foodCategories: "categoriesStatic", food: "foodStatic")
    
    override init(){
        super.init()
        readFromFiles()
    }
    
    
    fileprivate func readFromFiles(){
        if let path = Bundle.main.path(forResource: jsonFileNames.exersizes, ofType: "json")
        {
            do{
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                if let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                {
                    print(jsonResult)
                    syncExercises(array: jsonResult)
                }
            }catch{
                print("Could not load JSON file at path: \(path)")
            }
        }
    }
    
    fileprivate func syncExercises(array: NSArray){
        Sync.changes(array as! [[String : Any]], inEntityNamed: "Exercise", dataStack: dataStack) { (error) in
            if let error = error{
                print(error)
            }else{
                
            }
        }
    }
    
}
