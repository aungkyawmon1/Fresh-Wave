//
//  TabVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import UIKit
import RxSwift

class TabVC: UITabBarController {
    
    private var isPaymentProcessed: Bool = false
    
    private let shapeLayer = CAShapeLayer()
    
    private var customTabBar: CustomTabBar?
    
    private let viewModel: TabViewModel = TabViewModel(orderModel: OrderModelImpl.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpColors()
        setUpViewControllers()
        
        viewModel.fetchNearestAgent()
    }
    
    
    private func setUpColors() {
        customTabBar = { () -> CustomTabBar in
            let tabBar = CustomTabBar()
            return tabBar
        }()
           
        
        self.setValue(customTabBar, forKey: "tabBar")
        customTabBar?.isTranslucent = false
        customTabBar?.barTintColor = .white
        tabBar.dropShadow(opacity: 0.02, radius: 4, width: 0, height: 4)
        customTabBar?.tintColor = .primaryColor
        customTabBar?.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchOrderStatus()
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    //MARK: - Setup ViewControllers
    
    //Add viewModel References
    private func setUpViewControllers() {
        viewControllers?.removeAll()
    
        let home = HomeVC(viewModel: HomeViewModel(articleModel: ArticleModelImpl.shared))
     //  let navHome = UINavigationController(rootViewController: home)
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profile = ProfileVC(viewModel: ProfileViewModel())
      //  let navProfile = UINavigationController(rootViewController: profile)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 3)
        
        viewControllers = [home, profile]
        
    //    addShape()
    
        customTabBar = self.tabBar as? CustomTabBar
        
        customTabBar?.didTapButton = { [weak self] in
            guard let self = self else { return }
            if let orderVO = Preference.getCurrentOrderVO() {
                self.navigateToOrderDetail(orderVO: orderVO)
            } else {
                self.navigateToCartVC()
            }
        }
        
        
    }
    
    private func navigateToCartVC() {
        let vc = CartVC(viewModel: CartViewModel(orderModel: OrderModelImpl.shared))
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    private func navigateToOrderDetail(orderVO: OrderVO) {
       
        let vc = OrderDetailVC(orderVO: orderVO)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
    
    
}

extension TabVC: CartViewDelegate {
    func orderSuccess() {
        self.dismiss(animated: true)
        guard let orderVO = Preference.getCurrentOrderVO() else { return }
        navigateToOrderDetail(orderVO: orderVO)
    }
}


extension TabVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let controllers = self.navigationController?.viewControllers ?? []
        return controllers.count > 1
    }
}

extension TabVC {
    func addShape() {
        
        shapeLayer.removeFromSuperlayer()
       
        shapeLayer.path = createPathCircle()
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.shadowRadius = 1.0
        shapeLayer.shadowOpacity = 0.1
        shapeLayer.masksToBounds = false
        shapeLayer.fillColor = UIColor.white.cgColor
    
        self.tabBar.layer.insertSublayer(shapeLayer, at: 0)
        
        self.tabBar.layer.shadowPath = shapeLayer.path
    }
    
    func createPathCircle() -> CGPath {

        let radius: CGFloat = 30.0
        let path = UIBezierPath()
        let width = self.view.frame.width
        let height = self.view.frame.height
    
        let centerWidth = width  / 2
        

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        return path.cgPath
    }
    
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
