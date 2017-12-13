//
//  VIViewController.swift
//  htmlParser
//
//  Created by nemus on 2017. 11. 2..
//  Copyright © 2017년 nemus. All rights reserved.
//

import UIKit

class VIViewController: UIViewController {
    var fund : Int = 0

    @IBOutlet weak var presentingFund: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presentingFund.text = "\(fund)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
