//
//  DemoViewController.swift
//  AnalyticFramework
//
//  Created by Pinkesh Gajjar on 03/08/22.
//  Copyright © 2022 ProgrammingWithSwift. All rights reserved.
//

import UIKit


public class DemoViewController: UIViewController {
    
    @IBOutlet weak var btnClick: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getData() {
        print("From getData ...")
        SwirlsAPIService.sharedInstance.getSwrilData(){ (SwirlData) in
            
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        print("From Here ...")
        self.getData()
    }
    
}
