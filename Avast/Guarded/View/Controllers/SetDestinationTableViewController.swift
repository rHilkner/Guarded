//
//  SetDestinationTableViewController.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class SetDestinationTableViewController: UITableViewController {
    
    var sections = ["Endereço","Tempo Esperado","Protetores"]
    @IBOutlet weak var letras: UILabel!
    
    override func viewDidLoad() {
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
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numberofrows = 0
        if section == 0{
            numberofrows = 1;
        }else if section == 1{
            numberofrows = 1;
        }else if section == 2{
            numberofrows = (AppSettings.mainUser?.protectors.count)!
        }
        
        return numberofrows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let protectors = AppSettings.mainUser?.protectors
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationcell", for: indexPath) as! DestinationTableViewCell
            cell.address.text = "Roxo Moreira, 56"
            cell.city.text = "Campinas, SP"
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timercell", for: indexPath) as! TimerCellTableViewCell
            cell.timer.countDownDuration = TimeInterval(0.0)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "protectorcell", for: indexPath) as! ProtectorCellTableViewCell
            cell.protectorPic.image = UIImage(named: "Orange Pin")
            cell.protectorName.text = protectors![indexPath.row].name
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

	func getCurrentDate(){

		let date = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents([.year, .month, .day], from: date)

		let year =  components.year
		let month = components.month
		let day = components.day

		print(year)
		print(month)
		print(day)
	}
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
