//
//  OrderHistoryVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import UIKit

class OrderHistoryVC: BaseViewController {

    @IBOutlet weak var tableViewHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    private func setupTableView() {
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
        
        tableViewHistory.registerCell(from: OrderHistoryCell.self)
    }
    
    //MARK: - Route
    func navigateToOrderDetail() {
        let vc = OrderDetailVC()
        pushVC(vc)
    }

}


extension OrderHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToOrderDetail()
    }
}

extension OrderHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: OrderHistoryCell.self, at: indexPath)
        return cell
    }
    
}
