//
//  AddProtectorTableViewController.swift
//  Guarded
//
//  Created by Andressa Aquino on 13/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddProtectorTableViewController: UITableViewController {

	let searchController = UISearchController(searchResultsController: nil)

	@IBOutlet var addProtectorTableView: UITableView!

	var usersArray = [String]()
	var filteredUsers = [String]()

	var ref = Database.database().reference()

	override func viewDidLoad() {
        super.viewDidLoad()

		/// allows the class to know when the text inside the search bar has changed
		searchController.searchResultsUpdater = self

		searchController.dimsBackgroundDuringPresentation = false

		/// display the search bar only in this view controller
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar

		ref.child("users").queryOrdered(byChild: "name").observe(.childAdded, with: {
			(snapshot) in

			let userName = snapshot.childSnapshot(forPath: "name").value as! String

			if userName != AppSettings.mainUser?.name {
				self.usersArray.append(userName)

				// insert rows, only if search has begun
				if self.searchController.isActive && self.searchController.searchBar.text != ""{

					self.addProtectorTableView.insertRows(at: [IndexPath.init(row: self.usersArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
				}
			}


		}, withCancel: {
			(error) in

			print("Error in query users by name")

		})

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func filteredContent(searchText: String){

		self.filteredUsers = self.usersArray.filter({
			(user) in

			return (user.lowercased().contains(searchText.lowercased()))
		})

		addProtectorTableView.reloadData()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredUsers.count
		}

		return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addProtectorCell", for: indexPath)

		var user: String?

		if searchController.isActive && searchController.searchBar.text != "" {
			user = filteredUsers[indexPath.row]
			cell.textLabel?.text = user

		}

        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		var protectorName: String?

		if searchController.isActive && searchController.searchBar.text != "" {
			protectorName = filteredUsers[indexPath.row]
		} else {
			protectorName = self.usersArray[indexPath.row]
		}

		DatabaseManager.fetchProtector(protectorName: protectorName!) {
			(protector) in

			if (protector == nil) {
				print("Error on fetching protector's information.")
				return
			}

			if let protector = protector {
				DatabaseManager.addProtector(protector) {
					(error) in

					guard error == nil else {
						print("Error on adding protector to user's database object.")
						return
					}

					AppSettings.mainUser?.protectors.append(protector)

					self.navigationController?.popViewController(animated: true)
				}
			}
		}


	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddProtectorTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		filteredContent(searchText: self.searchController.searchBar.text!)
	}


}
