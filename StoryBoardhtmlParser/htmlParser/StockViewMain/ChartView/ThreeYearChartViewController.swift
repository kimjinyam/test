//
//  ThreeYearChartViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 20..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class ThreeYearChartViewController: UIViewController {
    var imgURL : String = ""
    var observer: AnyObject?
    
    @IBOutlet weak var titlename: UILabel!
    @IBOutlet weak var stockChartView: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBAction func BackButton(_ sender: Any) {
        NotificationCenter.default.removeObserver(observer)
        
        self.removeFromParentViewController()
        NotificationCenter.default.post(name: REMOVE_TABBAR_CONTROLLER, object: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlename.text = (self.tabBarController as! StockChartTabBarController).StockInfo.name

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observer = NotificationCenter.default.addObserver(forName: UPDATE_STOCK_CHARTS, object: nil, queue: nil) {
            notification in
            print("ThreeYearChartNotification")
            self.downloadPic(page: (URL(string:(self.tabBarController as! StockChartTabBarController).imgURL[4])!))
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(observer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadPic(page url: URL) {
        let downloadPicTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                error == nil else { return }
            do {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    let imageData = data
                    if imageData != nil {
                        let image = UIImage(data: imageData)
                        OperationQueue.main.addOperation {
                            self.stockChartView.image = image
                            self.price.text = (self.tabBarController as! StockChartTabBarController).StockInfo.price
                            if (self.tabBarController as! StockChartTabBarController).StockInfo.perChange.contains("+") {
                                self.price.textColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
                            } else if (self.tabBarController as! StockChartTabBarController).StockInfo.perChange.contains("-") {
                                self.price.textColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 1)
                            } else {
                                self.price.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                            }
                        }
                    }
                }
            } catch {
                
            }
            
        }
        downloadPicTask.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
