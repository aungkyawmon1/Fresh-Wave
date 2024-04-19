//
//  CartVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 24/03/2024.
//

import UIKit
import RxCocoa

protocol CartViewDelegate: AnyObject {
    func orderSuccess()
}

class CartVC: BaseViewController {
    
    @IBOutlet weak var btnNoOfBottlePlus: UIButton!
    @IBOutlet weak var btnNoOfBottleMinus: UIButton!
    @IBOutlet weak var btnNoOfFloorPlus: UIButton!
    @IBOutlet weak var btnNoOffloorMinus: UIButton!
    @IBOutlet weak var btnOrderNow: UIButton!
    @IBOutlet weak var lblNoOfBottle: UILabel!
    @IBOutlet weak var lblNoOfFloor: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    @IBOutlet weak var lblNewUserNote: UILabel!
    @IBOutlet weak var lblAgentAddress: UILabel!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFloorPrice: UILabel!
    @IBOutlet weak var lblBottleFee: UILabel!
    @IBOutlet weak var lblTotalFee: UILabel!
    @IBOutlet weak var bottleFeeView: UIStackView!
    
    private let viewModel: CartViewModel
    
    weak var delegate: CartViewDelegate?
    
    required init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bindViewModel(in: self)
        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        debugPrint("isnew", viewModel.isNewUser)
        btnNoOfBottlePlus.isHidden = !viewModel.isNewUser
        btnNoOfBottleMinus.isHidden = !viewModel.isNewUser
        btnNoOfFloorPlus.isHidden = !viewModel.isNewUser
        btnNoOffloorMinus.isHidden = !viewModel.isNewUser
        bottleFeeView.isHidden = !viewModel.isNewUser
        lblNewUserNote.isHidden = !viewModel.isNewUser
        
        lblNoOfBottle.text = "\(viewModel.currentOrderNumber)"
        lblNoOfFloor.text = "\(viewModel.currentFloorNumber)"
        lblUserAddress.text = viewModel.userAddress
        lblAgentName.text = viewModel.agentName
        lblAgentAddress.text = viewModel.agentAddress
        updatePrice()
    }
    
    private func updatePrice() {
        lblPrice.text = "\(viewModel.getUpdatedBasePrice()) MMK"
        lblFloorPrice.text = "\(viewModel.getUpdatedFloorPrice()) MMK"
        lblBottleFee.text = "\(viewModel.getUpdatedBottleFee()) MMK"
        lblTotalFee.text = "\(viewModel.getTotalPrice()) MMK"
    }
    
    override func bindData() {
        btnNoOffloorMinus.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            if viewModel.currentFloorNumber > 0 {
                self.viewModel.decreaseFloorNumber()
                self.lblNoOfFloor.text = "\(viewModel.currentFloorNumber)"
                updatePrice()
            } else {
                self.showMessage("Floor Number cannot be negative.")
            }
           
        }.disposed(by: disposableBag)
        
        btnNoOfFloorPlus.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            if viewModel.currentFloorNumber < 30 {
                self.viewModel.increaseFloorNumber()
                self.lblNoOfFloor.text = "\(viewModel.currentFloorNumber)"
                updatePrice()
            } else {
                self.showMessage("Floor Number cannot be greater than 30.")
            }
        }.disposed(by: disposableBag)
        
        btnNoOfBottleMinus.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            if viewModel.currentOrderNumber > 1 {
                self.viewModel.decreaseOrderNumber()
                self.lblNoOfBottle.text = "\(viewModel.currentOrderNumber)"
                updatePrice()
            } else {
                self.showMessage("Bottle Number cannot be zero.")
            }
        }.disposed(by: disposableBag)
        
        btnNoOfBottlePlus.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            if viewModel.currentOrderNumber < 15 {
                self.viewModel.increaseOrderNumber()
                self.lblNoOfBottle.text = "\(viewModel.currentOrderNumber)"
                updatePrice()
            } else {
                self.showMessage("Floor Number cannot be greater than 15.")
            }
        }.disposed(by: disposableBag)
        
        btnOrderNow.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            viewModel.placeOrder()
        }.disposed(by: disposableBag)
        
        viewModel.orderSuccessRelay.subscribe(onNext: { [weak self] response in
            guard let self = self, let _ = response else { return }
            self.showMessage("Order is successful", isSuccessfulState: true)
            self.delegate?.orderSuccess()
        }).disposed(by: disposableBag)
    }

}
