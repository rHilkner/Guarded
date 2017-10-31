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

class ProtectCollectionViewController: UICollectionViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addProtectorButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIndex = segmentedControl.selectedSegmentIndex
        
        if (reuseIndex == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "protectorCell", for: indexPath) as! ProtectorCollectionViewCell
            cell.personName.text = "Paulo"
            cell.profilePicture.image = UIImage(named: "collectionview_placeholder_image")
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "protectedCell", for: indexPath) as! ProtectedCollectionViewCell
            cell.personName.text = "Andressa"
            cell.profilePicture.image = UIImage(named: "collectionview_placeholder_image")
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
    
    func showActionSheet() {
        // 1
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let sendLocationAction = UIAlertAction(title: "Send Location", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                    let location = AppSettings.mainUser!.lastLocation
                    let alert = UIAlertController(title: "Send Location", message: "latitude: \(location!.latitude) longitude: \(location!.longitude)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)

            })
            optionMenu.addAction(sendLocationAction)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showActionSheet()
    }

    
}
