//
//  ViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 9. 28..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    let startUrl = URL(string: "http://finance.daum.net/quote/all.daum?type=U&stype=P&nil_stock=refresh")!
    var StockURL : String = "http://finance.daum.net/quote/all.daum?type=U&stype=P&nil_stock=refresh"
    
    private var stockTableViewController: UITableViewController!
    var timer:Timer?
    var finishTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewdidLoad()")
        visit(page: startUrl)
        self.startTimer()
        //self.finishTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(ViewController.timecheck), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func taskStart(_ sender: Any) {
        visit(page: URL(string: StockURL)!)
    }
    
    @IBAction func searchStock(_ sender: Any) {
        dataCenter.SearchedStockList.removeAll()
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchPopup") as! PopupViewController
        popOverVC.view.tag = 100
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        // create alert
        /*
        let alert = UIAlertController(title: "주식 검색", message: "원하는 주식의 이름을 입력하세요.", preferredStyle: .alert)
        
        // Add text field with handler
        alert.addTextField(configurationHandler: {
            (textField) -> Void in
            // listen for changes
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in
            let textf = alert.textFields![0] as UITextField
            for i in dataCenter.StockList {
                if (i.name.range(of: textf.text!) != nil) {
                    dataCenter.SearchedStockList.append(StockDetail(name: i.name, price: i.price, perChange: i.perChange))
                }
            }
            self.performSegue(withIdentifier: "SearchedStockSegue", sender: nil)
            print(dataCenter.SearchedStockList)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) -> Void in
            self.dismiss(animated: true, completion: {})
        }))
        
        self.present(alert, animated: true, completion: nil) */
    }
    

    @IBOutlet weak var TitleSegmentButton: UISegmentedControl!
    @IBOutlet weak var Industrial_average: UILabel!
    @IBOutlet weak var Debi: UILabel!
    @IBOutlet weak var Change_rate: UILabel!
    @IBOutlet weak var no_change: UILabel!
    @IBOutlet weak var upper_limit: UILabel!
    @IBOutlet weak var upper: UILabel!
    @IBOutlet weak var lower_limit: UILabel!
    @IBOutlet weak var lower: UILabel!
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc func update() {
        print("update")
        visit(page: URL(string: StockURL)!)
    }
    
    @IBAction func ChangePQ(_ sender: Any) {
        if TitleSegmentButton.selectedSegmentIndex == 0 {
            StockURL = "http://finance.daum.net/quote/all.daum?type=U&stype=P&nil_stock=refresh"
        } else {
            StockURL = "http://finance.daum.net/quote/all.daum?type=U&stype=Q&nil_stock=refresh"
        }
        visit(page: URL(string: StockURL)!)
    }
    
    @IBAction func perChangeSorting(_ sender: Any) {
        dataCenter.changeSortmode()
        stockTableViewController.tableView.reloadData()
    }
    
    var t = 0
    @objc func timecheck() {
        t = t + 1
    }
    
    func finishtimeerstart() {
        t = 0
        self.finishTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(ViewController.timecheck), userInfo: nil, repeats: true)
    }
    
    func visit(page url: URL) {
        self.finishtimeerstart()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let document = String(data: data, encoding: .utf8) else { return }
            do {
                let doc = try SwiftSoup.parse(document)
                do {
                    let td_element = try doc.select("td").array()
                    let href_element = try doc.select("a").array()
                    var resultarray : [String] = []
                    var resultarray2 : [String] = []
                    do {
                        for i in 0..<td_element.count {
                            let text = try td_element[i].text()
                            resultarray.append(text)
                        }
                        for i in 0..<href_element.count {
                            let text = try href_element[i].attr("href")
                            resultarray2.append(text)
                        }
                        OperationQueue.main.addOperation {
                            dataCenter.Synthesis.removeAll()
                            dataCenter.StockList.removeAll()
                            
                            // 다음 주식 사이트의 주식정보들을 저장공간에 넣기
                            var i = 0
                             while(i < resultarray.count) {
                                if(resultarray[i] != "") {
                                    if(i < 9) {
                                        dataCenter.Synthesis.append(resultarray[i])
                                        i = i + 1
                                    }
                                    else {
                                            // 중복자료 제거를 위해 추가
                                        guard let test = dataCenter.StockList.index(where: {$0.name == resultarray[i]}) else {
                                            dataCenter.StockList.append(StockDetail(name: resultarray[i], price: resultarray[i+1], perChange: resultarray[i+2]))
                                            i = i + 3
                                            continue
                                        }
                                        i = i + 3
                                    }
                                } else {
                                    i = i + 1
                                }
                            }

                            // 각 주식들의 세부사항이 들어있는 URL 주소 찾기
                            var count = 0
                            for k in resultarray2 {
                                if k.range(of: "/item/main.daum?") != nil && count < dataCenter.StockList.count{
                                        // 중복자료 제거를 위해 추가
                                    guard let test = dataCenter.StockList.index(where: {$0.stockURL == k}) else {
                                        dataCenter.StockList[count].setURL(stockURL : k)
                                        count = count + 1
                                        continue
                                    }
                                }
                                
                                if count > dataCenter.StockList.count {
                                    break;
                                }
                            }
                            
                            // 미리 정렬 준비해놓기
                            dataCenter.StockPerChangeSort(Stocks: dataCenter.StockList, SearchedStock: false)
                            
                            //self.TitleLabel.text = dataCenter.Synthesis[0]
                            self.Industrial_average.text = dataCenter.Synthesis[1]
                            self.Debi.text = dataCenter.Synthesis[2]
                            self.Change_rate.text = dataCenter.Synthesis[3]
                            self.no_change.text = dataCenter.Synthesis[6]
                            self.upper_limit.text = dataCenter.Synthesis[4]
                            self.upper.text = dataCenter.Synthesis[5]
                            self.lower_limit.text = dataCenter.Synthesis[8]
                            self.lower.text = dataCenter.Synthesis[7]
                            
                            self.stockTableViewController.tableView.reloadData() // refresh tableviewcell
                            dataCenter.crawlerStart = true
                            
                            dataCenter.updateStock()
                        }
                        
                    } catch {
                        
                    }
                } catch {
                    
                }
            } catch {
                
            }
        }
        task.resume()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StockTableViewController, segue.identifier == "stockTableSegue" {
            self.stockTableViewController = vc
        }
    }
  
}

