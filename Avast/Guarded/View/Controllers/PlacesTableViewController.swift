//
//  PlacesTableViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 25/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    
    var places: [Place] = []

	var watchSessionManager: WatchSessionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.watchSessionManager = WatchSessionManager()
		self.watchSessionManager?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Loading current user places
        loadPlaces()
        
        self.tableView.reloadData()
        
        print("User places: \(self.places.count)")
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

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


		let navigationController = tabBarController?.viewControllers?.first
		let mapViewController = navigationController?.childViewControllers[0] as! MapViewController

		
		mapViewController.centerInLocation(location: places[indexPath.row].coordinate)
		self.tabBarController?.selectedIndex = 0

	}
    
    func loadPlaces() {
        if let userPlaces = AppSettings.mainUser?.places {
            self.places = userPlaces
        }
    }
}

extension PlacesTableViewController: LockProtocol {
	func showLockScreen() {
		LockServices.setLockMode()

		let date = self.getCurrentDate()

		let helpOccurrence = HelpOccurrence(date: date, coordinate: (AppSettings.mainUser?.lastLocation)!)

		DatabaseManager.addHelpOccurrence(helpOccurrence: helpOccurrence){
			(error) in

			guard (error == nil) else {
				print("Error on adding a new help occurrence.")
				return
			}

		}

		AppSettings.mainUser?.status = userStatus.danger

		DatabaseManager.updateUserSatus() {
			(error) in
			if error != nil {

				print("Error on dismissing timer")
				return
			}
		}

		let vc = UIStoryboard(name:"Help", bundle:nil).instantiateViewController(withIdentifier: "LockScreen")

		vc.modalTransitionStyle = .crossDissolve

		self.present(vc, animated: true)
	}

	func getCurrentDate() -> String {

		let date = Date()

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"

		let dateString = dateFormatter.string(from: date)

		return dateString
	}
}
