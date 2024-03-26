//
//  CompleteProfileVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/03/2024.
//

import UIKit
import RxCocoa

class CompleteProfileVC: BaseViewController {

    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldFloor: UITextField!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblNoOfBottle: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    
    private let viewModel: CompleteProfileViewModel
    
    private var noOfBottole: Int = 1
    
    required init(viewModel: CompleteProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        title = "Register Account"
        btnRegister.layer.cornerRadius = btnRegister.frame.height / 2.0
    }
    
    private func updateNoOfBottle() {
        lblNoOfBottle.text = "\(noOfBottole)"
    }

    
    override func bindData() {
        
        txtFieldName.rx.text.map { $0 ?? ""}.bind(to: viewModel.nameSubject).disposed(by: disposableBag)
        
        btnMinus.rx.tap.bind {[weak self] in
            guard let self = self else { return }
           
            if noOfBottole < 2 {
                self.showMessage("No of bottles cannot be less than 1")
            } else {
                self.noOfBottole -= 1
                updateNoOfBottle()
            }
        }.disposed(by: disposableBag)
        
        btnPlus.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            if noOfBottole > 14 {
                self.showMessage("No of bottles cannot be greater than 15")
            } else {
                self.noOfBottole += 1
                updateNoOfBottle()
            }
            
        }.disposed(by: disposableBag)
        
        btnAddress.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.presentChooseAddressOnMap()
            
        }.disposed(by: disposableBag)
        
        btnRegister.rx.tap.bind {[weak self] in
            guard let self = self else { return }
           
        }.disposed(by: disposableBag)
        
        viewModel.areAllFieldsValid().bind(to: btnRegister.rx.isEnabled ).disposed(by: disposableBag)
        
        viewModel.areAllFieldsValid().map({ $0 ? 1.0 : 0.5}).bind(to: btnRegister.rx.alpha ).disposed(by: disposableBag)
        
    }
    
    private func presentChooseAddressOnMap() {
        let vc = ChooseAddressOnMapVC()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        self.present( navVC , animated: true)
    }

}

//MARK: - ChooseAddressOnMapDelegate
extension CompleteProfileVC: ChooseAddressOnMapDelegate {
    func chooseAddress(addressPlace: String, latitude: Double, longitude: Double) {
        txtFieldAddress.text = addressPlace
    }
    
    
}
