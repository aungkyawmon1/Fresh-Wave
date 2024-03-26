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
    
    private let viewModel: VerifyViewModel
    
    required init(viewModel: VerifyViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.requestOTPCode()
    }


    override func setupUI() {
        title = "Verify Account"
        
        otpFieldView.textContentType = .oneTimeCode
        otpFieldView.otpFilledBorderColor = UIColor(named: "colorPrimary") ?? .accent
        otpFieldView.otpFontSize = 16
        otpFieldView.otpDelegate = self
        otpFieldView.configure(with: 6)
        otpFieldView.becomeFirstResponder()
    }
    
    override func bindData() {
        otpFieldView.rx.text.map { $0 ?? "" }.bind(to: viewModel.otpSubject).disposed(by: disposableBag)
        viewModel.isValid().map { $0 }.bind(to: btnVerify.rx.isEnabled).disposed(by: disposableBag)
        viewModel.isValid().map { $0 ? 1.0 : 0.5 }.bind(to: btnVerify.rx.alpha).disposed(by: disposableBag)
        
        viewModel.isValid().subscribe(onNext: {[weak self] isValid in
            guard let self = self else { return }
            if isValid {
                self.viewModel.verifyOTPCode(verificationCode: otpFieldView.text ?? "")
            }
        }).disposed(by: disposableBag)
        
        btnVerify.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.verifyOTPCode(verificationCode: otpFieldView.text ?? "")
        }.disposed(by: disposableBag)
        
        viewModel.loginResponse.subscribe(onNext: {[weak self] response in
            guard let self = self, let _ = response else { return }
            self.navigateToHome()
        }).disposed(by: disposableBag)
        
        viewModel.showOTPMessage.subscribe(onNext: {[weak self] message in
            guard let self = self, let message = message else { return }
            self.showMessage(message)
        }).disposed(by: disposableBag)
        
    }
    
    
    //MARK: - Route
    private func navigateToHome() {
        AppCoordinator.shared.restart()
    }


}

extension VerifyVC : AEOTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String) {
        
      }
}
