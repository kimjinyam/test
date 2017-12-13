//
//  DataCenter.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 11..
//  Copyright © 2017년 nemus. All rights reserved.
//

import Foundation
import RealmSwift

let dataCenter:DataCenter = DataCenter()
let REFRESH_STOCKS = NSNotification.Name("RefreshNotification")

let UPDATE_STOCK_CHARTS = NSNotification.Name("ChartUpdateNotification")
let REMOVE_TABBAR_CONTROLLER = NSNotification.Name("RemoveTabbar")

class DataCenter {
    var Synthesis : [String]
    var StockList : [StockDetail]
    var SortedStockList : [StockDetail]
    var upperStockList : [StockDetail]
    var upperStockLong : [StockDetail]
    var lowerStockList : [StockDetail]
    var lowerStockLong : [StockDetail]
    var noChangeStockList : [StockDetail]
    
    var SearchedStockList : [StockDetail]
    var SortedSearchedStockList : [StockDetail]
    var upperSearchedStockList : [StockDetail]
    var upperSearchedStockLong : [StockDetail]
    var lowerSearchedStockList : [StockDetail]
    var lowerSearchedStockLong : [StockDetail]
    var noChangeSearchedStockList : [StockDetail]
    
    var perChangeSortmode : Int
    var crawlerStart : Bool
    var SearchName : String
    
    
    init() {
        Synthesis = []
        StockList = []
        SortedStockList = []
        upperStockList = []
        upperStockLong = []
        lowerStockList = []
        lowerStockLong = []
        noChangeStockList = []
        
        SearchedStockList = []
        SortedSearchedStockList = []
        upperSearchedStockList = []
        upperSearchedStockLong = []
        lowerSearchedStockList = []
        lowerSearchedStockLong = []
        noChangeSearchedStockList = []
        
        crawlerStart = false
        perChangeSortmode = 0
        SearchName = ""
    }
    
    func setSearchName (input : String) {
        self.SearchName = input
    }
    
    func updateStock() {
        if self.SearchName != "" {
            self.SearchedStockList.removeAll()
            for i in self.StockList {
                if (i.name.lowercased().range(of: self.SearchName.lowercased()) != nil) {
                    self.SearchedStockList.append(StockDetail(name: i.name, price: i.price, perChange: i.perChange, stockURL: i.stockURL))
                }
            }
        }
        NotificationCenter.default.post(name: REFRESH_STOCKS, object: nil)
    }
    
    func StockPerChangeSort(Stocks : [StockDetail], SearchedStock : Bool) {
        if SearchedStock == false {
            self.upperStockList.removeAll()
            self.lowerStockList.removeAll()
            self.noChangeStockList.removeAll()
            self.upperStockLong.removeAll()
            self.lowerStockLong.removeAll()
            for i in Stocks {
                if i.perChange.contains("+") {
                    if i.perChange.count > 6 {
                        self.upperStockLong.append(i)
                    } else {
                        self.upperStockList.append(i)
                    }
                } else if i.perChange.contains("-") {
                    if i.perChange.count > 6 {
                        self.lowerStockLong.append(i)
                    } else {
                        self.lowerStockList.append(i)
                    }
                } else {
                    self.noChangeStockList.append(i)
                }
            }
            self.upperStockLong = self.upperStockLong.sorted(by: {$0.perChange>$1.perChange})
            self.upperStockList = self.upperStockList.sorted(by: {$0.perChange>$1.perChange})
            self.lowerStockLong = self.lowerStockLong.sorted(by: {$0.perChange<$1.perChange})
            self.lowerStockList = self.lowerStockList.sorted(by: {$0.perChange<$1.perChange})
            self.SortedStockList = self.upperStockLong + self.upperStockList + self.noChangeStockList + self.lowerStockList + self.lowerStockLong
        } else {
            self.upperSearchedStockList.removeAll()
            self.lowerSearchedStockList.removeAll()
            self.noChangeSearchedStockList.removeAll()
            self.lowerSearchedStockLong.removeAll()
            self.upperSearchedStockLong.removeAll()
            for i in Stocks {
                if i.perChange.contains("+") {
                    if i.perChange.count > 6 {
                        self.upperSearchedStockLong.append(i)
                    } else {
                        self.upperSearchedStockList.append(i)
                    }
                } else if i.perChange.contains("-") {
                    if i.perChange.count > 6 {
                        self.lowerSearchedStockLong.append(i)
                    } else {
                        self.lowerSearchedStockList.append(i)
                    }
                } else {
                    self.noChangeSearchedStockList.append(i)
                }
            }
            self.upperSearchedStockLong = self.upperSearchedStockLong.sorted(by: {$0.perChange>$1.perChange})
            self.upperSearchedStockList = self.upperSearchedStockList.sorted(by: {$0.perChange>$1.perChange})
            self.lowerSearchedStockList = self.lowerSearchedStockList.sorted(by: {$0.perChange<$1.perChange})
            self.lowerSearchedStockLong = self.lowerSearchedStockLong.sorted(by: {$0.perChange<$1.perChange})
            self.SortedSearchedStockList = self.upperSearchedStockLong + self.upperSearchedStockList + self.noChangeSearchedStockList + self.lowerSearchedStockList + self.lowerSearchedStockLong
        }
    }
    
    func changeSortmode() {
        if self.perChangeSortmode == 0 {
            self.perChangeSortmode = 1
        } else if self.perChangeSortmode == 1 {
            self.perChangeSortmode = 2
        } else if self.perChangeSortmode == 2 {
            self.perChangeSortmode = 0
        }
    }
}

class StockDetail {
    var name : String
    var price : String
    var perChange : String
    var stockURL : String
    
    init(name: String, price: String, perChange: String , stockURL: String = "") {
        self.name = name
        self.price = price
        self.perChange = perChange
        self.stockURL = stockURL
    }
    
    init () {
        name = ""
        price = ""
        perChange = ""
        stockURL = ""
    }
    
    func setURL(stockURL: String) {
        self.stockURL = stockURL
    }
}
