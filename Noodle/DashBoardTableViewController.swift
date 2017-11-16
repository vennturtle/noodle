//
//  DashboardTableViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/15/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import Firebase

class DashBoardTableViewController: UITableViewController {
    
    var currentSurveys: [Survey] = []
    var myRef = FIRDatabase.database().reference()
    var t: String = ""
    var titles: [String] = []
    
    
    
    
    
    //var titles = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        loadTitles()
        //    tableView.reloadData()
        if let uid =  FIRAuth.auth()?.currentUser?.uid {
            let ref = myRef.child("Surveys").queryOrdered(byChild: "uid").queryEqual(toValue : uid )
            ref.observeSingleEvent(of:.value, with: { (snapshot) in
                
                // ref.observeSingleEvent(of: .value, with: { snapshot in
                for snap in snapshot.children{
                    
                let survey = Survey(snapshot: snap as! FIRDataSnapshot)!
                    
                    
                    
                    print(survey.title )
                    print("\n\\n\n\n\n\n")
                    
                    self.titles.append(survey.title)
                   // let title = myDict?[""] as! String
//                    self.titles.append(title)
//                    
//                    self.t = title
                    
                    //
                    //  cell.surveyLabel.text = title
                    
                    
                    
                    //   print(title)
                }
                self.tableView.reloadData()

            })
        }
        
        
    }
    //  })
    //}
    
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    
//    private func loadTitles()
//    {
//        
//        titles.append("this is a test title")
//    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(titles.count)
        return titles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as?
            
            HomeTableViewCell else { fatalError("The dequeued cell is not an instance of MealTableViewCell.") }
        
//        for s in titles.count{
        cell.surveyLabel.text = titles[indexPath.row]
    
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
