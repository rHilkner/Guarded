//
//  PhoneTableViewController.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 11/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit


class PhoneTableViewController: UITableViewController {
    
    let names = ["Polícia Militar", "Samu", "Bombeiros", "Guarda Municipal", "Defesa Civil", "Disque Denúncia"]
    let numbers = ["190", "192", "193", "153", "199", "181"]
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.names.count
    }
    
    //override func viewDidAppear(_ animated: Bool) {
        
        
    //}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let  phoneAlertController = UIAlertController(title: "\(self.numbers[indexPath.row])", message: "\(self.names[indexPath.row])", preferredStyle: UIAlertControllerStyle.alert)
        
        phoneAlertController.addAction(UIAlertAction(title: "Ligar", style: UIAlertActionStyle.default, handler: {action in
            let phone  = URL(string: "tel://\(self.numbers[indexPath.row])")
            UIApplication.shared.open(phone!)
        }))
        phoneAlertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(phoneAlertController, animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)

        cell.textLabel?.text = self.names[indexPath.row]
        cell.detailTextLabel?.text = self.numbers[indexPath.row]

        return cell
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
