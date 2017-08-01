//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/31/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // Variables
    var avatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        
        return AvatarCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    @IBAction func segmentControlChanged (_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 1 {
            avatarType = AvatarType.light
            collectionView.reloadData()
        } else {
            avatarType = AvatarType.dark
            collectionView.reloadData()
        }
    }
    
    @IBAction func backPressed (_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
