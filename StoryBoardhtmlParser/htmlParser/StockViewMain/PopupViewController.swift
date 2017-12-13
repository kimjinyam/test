//
//  PopupViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 10. 13..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController ,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        TextInput.returnKeyType = UIReturnKeyType.go
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var TextInput: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TextInput {
            TextInput.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func openSearchedStocks(_ sender: Any) {
        if let textf = TextInput.text {
            for i in dataCenter.StockList {
                if (i.name.lowercased().range(of: textf.lowercased()) != nil) {
                    dataCenter.SearchedStockList.append(StockDetail(name: i.name, price: i.price, perChange: i.perChange))
                }
            }
        }
        dataCenter.perChangeSortmode = 0
        self.performSegue(withIdentifier: "SearchedStockSegue", sender: nil)
        removeSubview()
//        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func closePopup(_ sender: Any) {
        removeSubview()
//        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func removeSubview() {
        if let viewwithTag = self.view.viewWithTag(100) {
            viewwithTag.removeFromSuperview()
        } else {
            print("뷰 안지워짐")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SearchedStockSegue" {
            if let nextview = segue.destination as? SearchedStockTableViewController {
                nextview.titleName = TextInput.text!
            }
        }
    }
    

}
