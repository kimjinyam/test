//
//  StockChartTabBarController.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 20..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit
import SwiftSoup


class StockChartTabBarController: UITabBarController {
    var StockInfo : StockDetail = StockDetail()
    var imgURL : [String] = []
    var observer: AnyObject?
    var observer2: AnyObject?
    var imgcrawler : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        observer = NotificationCenter.default.addObserver(forName: REMOVE_TABBAR_CONTROLLER, object: nil, queue: nil) {
            notification in
            print("TabbarDeleteNotification")
            self.dismiss(animated: true, completion: nil)
            self.removeFromParentViewController()
        }
        
        observer2 = NotificationCenter.default.addObserver(forName: REFRESH_STOCKS, object: nil, queue: nil) {
            notification in
            print("updateChartImg")
            self.imgcrawler = false
            self.visit(page: URL(string: "http://finance.daum.net" + self.StockInfo.stockURL)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func visit(page url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let document = String(data: data, encoding: .utf8) else { return }
            if self.imgcrawler == false {
                do {
                    let doc = try SwiftSoup.parse(document)
                    do {
                        let img_element = try doc.select("img").array()
                        do {
                             self.imgURL.removeAll()
                             var i = 0
                             while(i < 5) {
                                 let text = try img_element[i].attr("src")
                                 self.imgURL.append(text)
                                 i = i + 1
                             }
                            OperationQueue.main.addOperation {
                                NotificationCenter.default.post(name: UPDATE_STOCK_CHARTS, object: nil)
                                self.imgcrawler = true
                            }
                        } catch {
                            
                        }
                    } catch {
                        
                    }
                } catch {
                    
                }
            }
            else {
                NotificationCenter.default.post(name: UPDATE_STOCK_CHARTS, object: nil)
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visit(page: URL(string: "http://finance.daum.net" + self.StockInfo.stockURL)!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self.observer)
        NotificationCenter.default.removeObserver(self.observer2)
        self.removeFromParentViewController()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        visit(page: URL(string: "http://finance.daum.net" + self.StockInfo.stockURL)!)
        //NotificationCenter.default.post(name: UPDATE_STOCK_CHARTS, object: nil)
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
}
