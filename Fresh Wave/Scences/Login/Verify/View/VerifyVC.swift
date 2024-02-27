//
//  VerifyVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import UIKit
import RxCocoa
import AEOTPTextField

class VerifyVC: BaseViewController {

    @IBOutlet weak var otpFieldView: AEOTPTextField!
    @IBOutlet weak var btnVerify: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func setupUI() {
        title = "Verify Account"
        
        otpFieldView.textContentType = .oneTimeCode
        otpFieldView.otpFilledBorderColor = UIColor(named: "colorPrimary") ?? .accent
        otpFieldView.otpFontSize = 16
        otpFieldView.otpDelegate = self
        otpFieldView.configure(with: 6)
    }
    
    override func bindData() {
        super.bindData()
        
        btnVerify.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            debugPrint("Tap")
        }.disposed(by: disposableBag)
    }


}

extension VerifyVC : AEOTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String) {
        
      }
}
