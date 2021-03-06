//
//  SettingsTableViewController.swift
//  Guarded
//
//  Created by Filipe Marques on 12/12/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import Nuke

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var mainUserName: UILabel!
    @IBOutlet weak var mainUserEmail: UILabel!
    @IBOutlet weak var mainUserPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainUser = AppSettings.mainUser
        self.mainUserName.text = mainUser?.name
        self.mainUserEmail.text = mainUser?.email
        self.mainUserPicture.layer.cornerRadius = (self.mainUserPicture.frame.height)/2
        self.mainUserPicture.backgroundColor = UIColor.lightGray
        self.mainUserPicture.image = UIImage(named: "collectionview_placeholder_image")
        Manager.shared.loadImage(with: AppSettings.mainUser!.profilePictureURL, into: self.mainUserPicture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 1{
            
            let text = "Melhore a sua segurança e de todos ao seu redor, confira Protect para o seu smartphone. Baixe:"
            let activityViewController = UIActivityViewController(activityItems: [text as NSString], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)

        }
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
