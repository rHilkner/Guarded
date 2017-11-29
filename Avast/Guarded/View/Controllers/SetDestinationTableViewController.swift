//
//  SetDestinationTableViewController.swift
//  Guarded
//
//  Created by Paulo Henrique Fonseca on 28/11/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class SetDestinationTableViewController: UITableViewController {
    
    var locationInfo: LocationInfo!
    var sections = ["Endereço","Tempo Esperado","Protetores"]
    var timerValue:TimeInterval!
    
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
            cell.address.text = locationInfo.name
            cell.city.text = "\(locationInfo.city), \(locationInfo.state), \(locationInfo.country)"
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timercell", for: indexPath) as! TimerCellTableViewCell
            cell.delegate = self
            cell.timer.countDownDuration = TimeInterval(0.0)
            self.timerValue = cell.timer.countDownDuration
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "protectorcell", for: indexPath) as! ProtectorCellTableViewCell
            cell.protectorPic.image = UIImage(named: "Orange Pin")
            cell.protectorName.text = protectors![indexPath.row].name
            cell.protectorId = protectors![indexPath.row].id
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 131
        } else {
            return 44
        }
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        
        var id = [String]()
        
        let section = 2
        let rows = tableView.numberOfRows(inSection: section)
        for i in 0..<rows {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: section)) as! ProtectorCellTableViewCell
            if cell.protectorOnOff.isOn {
                id.append(cell.protectorId)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension SetDestinationTableViewController: TimerCellTableViewCellDelegate {
    func didChangeValue(cell: TimerCellTableViewCell, picker: UIDatePicker) {
        self.timerValue = cell.timer.countDownDuration
    }
}

