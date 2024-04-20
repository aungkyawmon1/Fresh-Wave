//
//  OrderHistoryVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import UIKit

class OrderHistoryVC: BaseViewController {

    @IBOutlet weak var tableViewHistory: UITableView!
    
    private let viewModel: OrderHistoryViewModel
    
    required init(viewModel: OrderHistoryViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        
        viewModel.bindViewModel(in: self)
        
        viewModel.getOrderHistory()
    }
    
    private func setupTableView() {
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
        
        tableViewHistory.registerCell(from: OrderHistoryCell.self)
    }
    
    override func bindData() {
        viewModel.orderHistoryList.subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.tableViewHistory.reloadData()
        }).disposed(by: disposableBag)
    }
    
    //MARK: - Route
    func navigateToOrderDetail(orderVO: OrderVO) {
        let vc = OrderDetailVC(orderVO: orderVO)
        pushVC(vc)
    }

}


extension OrderHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let orderVO = viewModel.getOrderVO(at: indexPath.row) else { return }
        navigateToOrderDetail(orderVO: orderVO)
    }
}

extension OrderHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noOfOrder()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: OrderHistoryCell.self, at: indexPath)
        cell.orderVO = viewModel.getOrderVO(at: indexPath.row)
        return cell
    }
    
}
