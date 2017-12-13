//
//  VIConfigurationViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 11. 2..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class VIConfigurationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerData : [String] = [String]()
    var fund : Int = 0

    @IBOutlet weak var assetSetup: UIPickerView!
    @IBOutlet weak var fundselected: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.assetSetup.delegate = self
        self.assetSetup.dataSource = self

        pickerData = ["10만", "100만", "1000만", "1억", "10억"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            self.fund = 100000
        case 1:
            self.fund = 1000000
        case 2:
            self.fund = 10000000
        case 3:
            self.fund = 100000000
        case 4:
            self.fund = 1000000000
        default: break
        }
        fundselected.text = "\(self.fund)"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if let vc = segue.destination as? VIViewController,  segue.identifier == "VIstartsegue" {
            vc.fund = self.fund
        }

    }
}
