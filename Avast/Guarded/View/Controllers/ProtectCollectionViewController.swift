//
//  ProtectCollectionViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 28/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Nuke

class ProtectCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addProtectorButton: UIBarButtonItem!
    
    var protectors = [Protector]()
    var protected = [Protected]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadActors()
    }
    
    func loadActors() {
        if let userProtectors = AppSettings.mainUser?.protectors {
            self.protectors = userProtectors
        } else {
            self.protectors = [Protector]()
        }
        
        if let userProtected = AppSettings.mainUser?.protecteds {
            self.protected = userProtected
        } else {
            self.protected = [Protected]()
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //Return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let reuseIndex = segmentedControl.selectedSegmentIndex
        if (reuseIndex == 0) {
            return self.protectors.count
        } else {
            return self.protected.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIndex = segmentedControl.selectedSegmentIndex
        
        if (reuseIndex == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "protectorCell", for: indexPath) as! ProtectorCollectionViewCell
            cell.personName.text = protectors[indexPath.row].name
            cell.profilePicture.image = UIImage(named: "collectionview_placeholder_image")
            Manager.shared.loadImage(with: protectors[indexPath.row].profilePictureURL, into: cell.profilePicture)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "protectedCell", for: indexPath) as! ProtectedCollectionViewCell
            cell.personName.text = protected[indexPath.row].name
            cell.profilePicture.image = UIImage(named: "collectionview_placeholder_image")
            Manager.shared.loadImage(with: protected[indexPath.row].profilePictureURL, into: cell.profilePicture)
            cell.pin.image = UIImage(named:"Orange Pin")
            return cell
            
        }
    }
    
    @IBAction func segControlChanged(_ sender: UISegmentedControl) {
        self.collectionView?.reloadData()
        
        self.addProtectorButton.isEnabled = !self.addProtectorButton.isEnabled
        
        if (self.addProtectorButton.isEnabled == true) {
            self.addProtectorButton.tintColor = UIApplication.shared.keyWindow?.tintColor
        } else {
            self.addProtectorButton.tintColor = UIColor.clear
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            /// Show in the alert if the protector is currently able to follow you or not
            var title  = "Protecting you: "
            if protectors[index].protectingYou == true {
                title = title + "ON"
            }
            else {
                title = title + "OFF"
            }
            
            
            let changeStatusAction = UIAlertAction(title: title, style: .default) {
                (alert: UIAlertAction!) -> Void in
                
                /// Change status of protector in local variable and in DB
                if self.protectors[index].protectingYou == true {
                    self.protectors[index].protectingYou = false
                    
                    DatabaseManager.deactivateProtector(self.protectors[index]) {
                        (error) in
                        
                        guard error == nil else{
                            print("Error in deactivating protector")
                            return
                        }
                    }
                }
                else {
                    self.protectors[index].protectingYou = true
                    DatabaseManager.addProtector(self.protectors[index]) {
                        (error) in
                        
                        guard error == nil else {
                            print("Error in deactivating protector")
                            return
                        }
                    }
                }
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                (alert: UIAlertAction!) -> Void in
                AppSettings.mainUser!.removeProtector(self.protectors[index])
                self.protectors.remove(at: index)
                self.collectionView?.reloadData()
            }
            
            /// id do protector - protected - seu id - change status
            optionMenu.addAction(changeStatusAction)
            optionMenu.addAction(deleteAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        }
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}
