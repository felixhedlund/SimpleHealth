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


protocol ExercisesAwaitingSyncDelegate{
    func exercisesWereSynced()
}
protocol FoodCategoriesAwaitingSyncDelegate{
    func foodCategoriesWereSynced()
}

protocol FoodAwaitingSyncDelegate{
    func foodWereSynced()
}


let dataStack = DATAStack(modelName: "SimpleHealth")
class DataCenter: NSObject{
    
    var exercisesDelegate: ExercisesAwaitingSyncDelegate?
    var foodCategoriesDelegate: FoodCategoriesAwaitingSyncDelegate?
    var foodDelegate: FoodAwaitingSyncDelegate?
    let jsonFileNames = (exersizes: "exercisesStatic", foodCategories: "categoriesStatic", food: "foodStatic")
    override init(){
        super.init()
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "syncFood") && defaults.bool(forKey: "syncExercises") && defaults.bool(forKey: "syncFoodCategories"){
            print("All data was previously synched")
        }else{
            readFromFiles()
        }
        
    }
    
    
    fileprivate func readFromFiles(){
        
        DispatchQueue.global(qos: .background).async {
            let defaults = UserDefaults.standard
            for index in 0...2{
                var pathName = ""
                
                switch index{
                case 0:
                    pathName = self.jsonFileNames.exersizes
                    if defaults.bool(forKey: "syncExercises"){
                        continue
                    }
                case 1:
                    pathName = self.jsonFileNames.foodCategories
                    if defaults.bool(forKey: "syncFoodCategories"){
                        continue
                    }
                case 2:
                    pathName = self.jsonFileNames.food
                    if defaults.bool(forKey: "syncFood"){
                        continue
                    }
                default:
                    pathName = ""
                }
                
                if let path = Bundle.main.path(forResource: pathName, ofType: "json")
                {
                    do{
                        let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                        if let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray
                        {
                            
                            switch index{
                            case 0:
                                print("Sync Exersices")
                                self.syncExercises(array: jsonResult)
                            case 1:
                                print("Sync FoodCategories")
                                self.syncFoodCategories(array: jsonResult)
                            case 2:
                                print("Sync Food")
                                self.syncFood(array: jsonResult)
                            default:
                                print()
                            }
                            
                        }
                    }catch{
                        print("Could not load JSON file at path: \(path)")
                    }
                }
            }
        }
        
        
    }
    
    fileprivate func syncFood(array: NSArray){
        DispatchQueue.global(qos: .background).async {
            Sync.changes(array as! [[String : Any]], inEntityNamed: "Food", dataStack: dataStack) { (error) in
                if let error = error{
                    print(error)
                }else{
                    DispatchQueue.main.async {
                        if let delegate = self.foodDelegate{
                            delegate.foodWereSynced()
                            let defaults = UserDefaults.standard
                            defaults.set(true, forKey: "syncFood")
                        }
                    }
                }
            }
        }
        
        
    }
    
    fileprivate func syncExercises(array: NSArray){
        
        DispatchQueue.global(qos: .background).async {
            Sync.changes(array as! [[String : Any]], inEntityNamed: "Exercise", dataStack: dataStack) { (error) in
                if let error = error{
                    print(error)
                }else{
                    DispatchQueue.main.async {
                        if let delegate = self.exercisesDelegate{
                            delegate.exercisesWereSynced()
                            let defaults = UserDefaults.standard
                            defaults.set(true, forKey: "syncExercises")
                        }
                    }
                }
            }
        }
        
    }
    fileprivate func syncFoodCategories(array: NSArray){
        
        DispatchQueue.global(qos: .background).async {
            Sync.changes(array as! [[String : Any]], inEntityNamed: "FoodCategory", dataStack: dataStack) { (error) in
                if let error = error{
                    print(error)
                }else{
                    DispatchQueue.main.async {
                        if let delegate = self.foodCategoriesDelegate{
                            delegate.foodCategoriesWereSynced()
                            let defaults = UserDefaults.standard
                            defaults.set(true, forKey: "syncFoodCategories")
                        }
                    }
                }
        }
        
        
        }
        
    }
    
}
