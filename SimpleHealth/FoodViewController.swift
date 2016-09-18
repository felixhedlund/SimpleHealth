//
//  FoodViewController.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 18/09/16.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit
import IBAnimatable
import CoreData

protocol FoodsReturnDelegate{
    func didReturnFromFoods()
}

class FoodViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, FoodAwaitingSyncDelegate {
    @IBOutlet weak var exitButton: AnimatableButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var returnDelegate: FoodsReturnDelegate!
    var foods = [Food]()
    var categoryId: Int16?
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataCenter = (UIApplication.shared.delegate as! AppDelegate).dataCenter!
        dataCenter.foodDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateArrayWith(searchString: searchBar.text, categoryId: categoryId)
    }
    
    func foodWereSynced() {
        updateArrayWith(searchString: searchBar.text, categoryId: categoryId)
    }

    
    fileprivate func updateArrayWith(searchString: String?, categoryId: Int16?){
        let foodFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        var didAppendCategoryId = false
        var didAppendSearchString = false
        var subPredicates = [NSPredicate]()
        if let id = self.categoryId{
            let predicate = NSPredicate(format: "ocategoryid == \(id)")
   //         let predicate = NSPredicate(format: "ocategoryid == %@", id)
            subPredicates.append(predicate)
            didAppendCategoryId = true
        }
        if let searchString = searchString {
            if searchString.characters.count > 0{
                subPredicates.append(NSPredicate(format: "title CONTAINS %@", searchString))
                didAppendSearchString = true
            }
            
        }
        
        if didAppendCategoryId && didAppendSearchString{
            foodFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        }else if didAppendCategoryId || didAppendSearchString{
            foodFetch.predicate = subPredicates[0]
        }
        do{
            if let fetchedFoods = try dataStack.mainContext.fetch(foodFetch) as? [Food]{
                self.foods = fetchedFoods
                collectionView.reloadData()
            }
        } catch {
            fatalError("Failed to fetch exercises: \(error)")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0{
            updateArrayWith(searchString: nil, categoryId: self.categoryId)
        }else{
            updateArrayWith(searchString: searchText, categoryId: self.categoryId)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Content", for: indexPath) as! ContentCollectionViewCell
        cell.setupCell(name: self.foods[indexPath.row].title)
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressExitButton(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            self.returnDelegate.didReturnFromFoods()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
