//
//  SearchedStockTableViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 13..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class SearchedStockTableViewController: UITableViewController {
    
    var titleName : String = ""
    var observer: AnyObject?
    
    @IBOutlet weak var searchedStockTitle: UINavigationItem!
    
    @IBAction func perChangeSort(_ sender: Any) {
        dataCenter.changeSortmode()
        self.tableView.reloadData()
    }

    
    @IBAction func backButton(_ sender: Any) {
        NotificationCenter.default.removeObserver(observer)
        dataCenter.perChangeSortmode = 0
        self.dismiss(animated: true, completion: nil)
        self.removeFromParentViewController()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        searchedStockTitle.title = titleName + " 검색 결과"
        dataCenter.setSearchName(input : titleName)
        dataCenter.StockPerChangeSort(Stocks: dataCenter.SearchedStockList, SearchedStock: true)
        observer = NotificationCenter.default.addObserver(forName: REFRESH_STOCKS, object: nil, queue: nil) {
            notification in
            print("notification")
            
            dataCenter.StockPerChangeSort(Stocks: dataCenter.SearchedStockList, SearchedStock: true)
            
            self.tableView.reloadData()
        }
        dataCenter.updateStock()
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
        let rowCount = dataCenter.SearchedStockList.count
        
        return rowCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedStockCell", for: indexPath) as! SearchedStockTableViewCell

        // Configure the cell...
        var row : Int = 0
        if dataCenter.perChangeSortmode == 1 || dataCenter.perChangeSortmode == 0 {
            row = indexPath.row
        } else if dataCenter.perChangeSortmode == 2 {
            row = dataCenter.SearchedStockList.count - indexPath.row - 1
        }
        
        var name : String = ""
        var price : String = ""
        var perChange : String = ""
        
        if dataCenter.perChangeSortmode == 0 {
            name = dataCenter.SearchedStockList[row].name
            price = dataCenter.SearchedStockList[row].price
            perChange = dataCenter.SearchedStockList[row].perChange
        } else {
            name = dataCenter.SortedSearchedStockList[row].name
            price = dataCenter.SortedSearchedStockList[row].price
            perChange = dataCenter.SortedSearchedStockList[row].perChange
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tempURL = "http://finance.daum.net"
        tempURL = tempURL + dataCenter.SearchedStockList[indexPath.row].stockURL
        //UIApplication.shared.open(URL(string: tempURL)!, options: [:], completionHandler: nil)
        //print("\(dataCenter.SearchedStockList[indexPath.row].stockURL)")
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
        if let tvc = segue.destination as? StockChartTabBarController, segue.identifier == "chartview2" {
            if let indexpath = self.tableView.indexPathForSelectedRow {
                if dataCenter.perChangeSortmode == 0 {
                    tvc.StockInfo = dataCenter.SearchedStockList[indexpath.row]
                } else if dataCenter.perChangeSortmode == 1 {
                    tvc.StockInfo = dataCenter.SortedSearchedStockList[indexpath.row]
                } else {
                    tvc.StockInfo = dataCenter.SortedSearchedStockList[dataCenter.SortedSearchedStockList.count - indexpath.row - 1]
                }
            }
        }
    }
    

}
