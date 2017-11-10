//
//  PlacesTableViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 25/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    var places = [Place]()
    
    override func viewDidLoad() {
        loadPlaces()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.places.count
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        // Configure the cell...
        cell.placePin.image = UIImage(named:"Orange Pin")
        cell.placeLabel.text = self.places[indexPath.row].name
        cell.placeAddress.text = self.places[indexPath.row].address
        
        return cell
    }
    
    func loadPlaces() {
        if let userPlaces = AppSettings.mainUser?.places {
            self.places = userPlaces
        } else {
            self.places = [Place]()
        }
    }
}
