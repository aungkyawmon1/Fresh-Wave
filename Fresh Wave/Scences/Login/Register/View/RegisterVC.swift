//
//  RegisterVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import UIKit

class RegisterVC: BaseViewController {

    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldFloor: UITextField!
    @IBOutlet weak var txtFieldNoOfBottle: UITextField!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupUI() {
        title = "Register Account"
        btnRegister.layer.cornerRadius = btnRegister.frame.height / 2.0
    }
    
    override func bindData() {
        btnAddress.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            
        }.disposed(by: disposableBag)
        
        btnRegister.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            
        }.disposed(by: disposableBag)
    }

}
