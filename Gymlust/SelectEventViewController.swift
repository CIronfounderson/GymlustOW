//
//  SelectMatchTableViewController.swift
//  Gymlust
//
//  Created by Eric de Haan on 03-01-18.
//  Copyright © 2018 Eric de Haan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var events = [Event]()
    var databaseRef: DatabaseReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var eventCode = ""
    
    @IBOutlet weak var tableview: UITableView!
    
//    weak var delegate:SelectEventDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the database service
        databaseRef = Database.database().reference()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell

        // Configure the cell...
        cell.lblDescription.text = self.events[indexPath.row].description

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate?.didSelectEvent(sender: self, eventCode: self.events[indexPath.row].code)
        self.eventCode = self.events[indexPath.row].code
        self.performSegue(withIdentifier: "sgShowEvent", sender: self)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgShowEvent" {
            let vc:TournamentViewController = segue.destination as! TournamentViewController
            vc.tournamentName = eventCode
        }
    }

    func getData() {
        print("GetData")
        databaseRef.child("matches").queryOrdered(byChild: "date").observeSingleEvent(of: .value, with: { (snapshot) in
            if let eventsDict = snapshot.value as? [String:AnyObject]{
                self.events = [Event]()
                for eventObj in eventsDict {
                    let eventDict = eventObj.value as! NSDictionary
                    let code = eventObj.key
                    let description = eventDict["description"] as! String
                    let date = eventDict["date"] as! String
                    let event = Event()
                    event.code = code
                    event.description = description
                    event.date = date
                    
                    self.events.append(event)
                }
//                self.tournament.rearrange(order: SortOrder.StartingOrder)
                
                self.tableview.reloadData()
                
            }
            
        })
        
    }

}
