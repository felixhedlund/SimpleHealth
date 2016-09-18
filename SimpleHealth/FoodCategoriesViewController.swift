//
//  FoodCategoriesViewController.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 18/09/16.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit
import IBAnimatable
import CoreData

protocol FoodCategoriesReturnDelegate{
    func didReturnFromFoodCategories(shouldShowFoods: Bool, foodCategoryId: Int16?)
}
class FoodCategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, FoodCategoriesAwaitingSyncDelegate {
    @IBOutlet weak var exitButton: AnimatableButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var returnDelegate: FoodCategoriesReturnDelegate!
    var categories = [FoodCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataCenter = (UIApplication.shared.delegate as! AppDelegate).dataCenter!
        dataCenter.foodCategoriesDelegate = self
        updateArrayWith(searchString: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    func foodCategoriesWereSynced() {
        updateArrayWith(searchString: searchBar.text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exitButton.fade(.in)
    }
    
    fileprivate func updateArrayWith(searchString: String?){
        let categoryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodCategory")
        if let s = searchString{
            categoryFetch.predicate = NSPredicate(format: "name_sv CONTAINS %@", s)
        }
        do{
            if let fetchedCategories = try dataStack.mainContext.fetch(categoryFetch) as? [FoodCategory]{
                self.categories = fetchedCategories
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
            updateArrayWith(searchString: nil)
        }else{
            updateArrayWith(searchString: searchText)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryId = self.categories[indexPath.row].oid
        self.dismiss(animated: true) { 
            self.returnDelegate.didReturnFromFoodCategories(shouldShowFoods: true, foodCategoryId: categoryId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Content", for: indexPath) as! ContentCollectionViewCell
        cell.setupCell(name: self.categories[indexPath.row].name_sv)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressExit(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            self.returnDelegate.didReturnFromFoodCategories(shouldShowFoods: false, foodCategoryId: nil)
        }
    }
    
    @IBAction func didPressViewAllFood(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            self.returnDelegate.didReturnFromFoodCategories(shouldShowFoods: true, foodCategoryId: nil)
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
