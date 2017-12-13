//
//  StockTableViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 11..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class StockTableViewController: UITableViewController {
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
        let rowCount = dataCenter.StockList.count
        //print("RowCount : \(rowCount)")
        return rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableViewCell

        var row : Int = 0
        if dataCenter.crawlerStart == true {
            if dataCenter.perChangeSortmode == 0 || dataCenter.perChangeSortmode == 1 {
                row = indexPath.row
            } else if dataCenter.perChangeSortmode == 2 {
                row = dataCenter.StockList.count - indexPath.row - 1
            }
            
            var name : String = ""
            var price : String = ""
            var perChange : String = ""
            
            if dataCenter.perChangeSortmode == 0 {
                name = dataCenter.StockList[row].name
                price = dataCenter.StockList[row].price
                perChange = dataCenter.StockList[row].perChange
            } else {
                name = dataCenter.SortedStockList[row].name
                price = dataCenter.SortedStockList[row].price
                perChange = dataCenter.SortedStockList[row].perChange
            }
            
            cell.stockname.text = name
            cell.price.text = price
            let change = perChange
            if change.contains("+")  {
                cell.perChange.textColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
            } else if change.contains("-") {
                cell.perChange.textColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 1)
            } else {
                cell.perChange.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
            cell.perChange.text = change
            
            //print("indexpath : (\(indexPath.section), \(indexPath.row))")
        }

        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tempURL = "http://finance.daum.net"
        tempURL = tempURL + dataCenter.StockList[indexPath.row].stockURL
        //UIApplication.shared.open(URL(string: tempURL)!, options: [:], completionHandler: nil)
        //print("\(dataCenter.StockList[indexPath.row].stockURL)")
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let tvc = segue.destination as? StockChartTabBarController, segue.identifier == "chartview1" {
            if let indexpath = self.tableView.indexPathForSelectedRow {
                if dataCenter.perChangeSortmode == 0 {
                    tvc.StockInfo = dataCenter.StockList[indexpath.row]
                } else if dataCenter.perChangeSortmode == 1 {
                    tvc.StockInfo = dataCenter.SortedStockList[indexpath.row]
                } else {
                    tvc.StockInfo = dataCenter.SortedStockList[dataCenter.SortedStockList.count - indexpath.row - 1]
                }
            }
        }
    }

}
