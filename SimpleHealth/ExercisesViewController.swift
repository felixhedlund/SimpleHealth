//
//  ExercisesViewController.swift
//  SimpleHealth
//
//  Created by Felix Hedlund on 18/09/16.
//  Copyright © 2016 FelixHedlund. All rights reserved.
//

import UIKit
import CoreData
import IBAnimatable
protocol ExercisesReturnDelegate{
    func didReturnFromExercises()
}

class ExercisesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, ExercisesAwaitingSyncDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exitButton: AnimatableButton!
    
    
    var exercises = [Exersice]()
    var returnDelegate: ExercisesReturnDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataCenter = (UIApplication.shared.delegate as! AppDelegate).dataCenter!
        dataCenter.exercisesDelegate = self
        updateArrayWith(searchString: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func exercisesWereSynced() {
        updateArrayWith(searchString: searchBar.text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        exitButton.fade(.in)
    }
    
    @IBAction func didPressExit(_ sender: AnyObject) {
        
        self.dismiss(animated: true) { 
            self.returnDelegate.didReturnFromExercises()
        }
    }
    
    
    
    
    fileprivate func updateArrayWith(searchString: String?){
        let exerciseFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        if let s = searchString{
            exerciseFetch.predicate = NSPredicate(format: "title CONTAINS %@", s)
        }
        do{
            if let fetchedExercises = try dataStack.mainContext.fetch(exerciseFetch) as? [Exersice]{
                self.exercises = fetchedExercises
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Content", for: indexPath) as! ContentCollectionViewCell
        cell.setupCell(name: self.exercises[indexPath.row].title)
        return cell
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
