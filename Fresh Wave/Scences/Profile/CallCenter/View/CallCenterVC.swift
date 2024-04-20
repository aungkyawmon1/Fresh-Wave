//
//  CallCenterVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 03/04/2024.
//

import UIKit

class CallCenterVC: UIViewController {

    @IBOutlet weak var ivCallNow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapCallNow = UITapGestureRecognizer(target: self, action: #selector(onTapCallNow))
        ivCallNow.isUserInteractionEnabled = true
        ivCallNow.addGestureRecognizer(tapCallNow)
    }
    
    @objc func onTapCallNow() {
        if let  CallURL:NSURL = NSURL(string:"tel://09753264227") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL( CallURL as URL)) {
                application.open(CallURL as URL)
            }
        }
    }

}
