//
//  LoadingIndicator.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import UIKit

class LoadingIndicator: UIView {
    
    private var containerView: UIView?
    private var box: UIView?
    private var indicator: UIActivityIndicatorView?
    private var isLoading: Bool = false
    
    static let shared = LoadingIndicator()
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startLoading() {
        if isLoading { return }
        
        let midX = UIScreen.main.bounds.midX
        let midY = UIScreen.main.bounds.midY
        let mid = CGPoint(x: midX, y: midY)
        
        containerView = UIView(frame: self.bounds)
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        addSubview(containerView!)
        
        box = UIView()
        box?.frame = CGRect(x: midX - 35, y: midY - 35, width: 70, height: 70)
        box?.layer.cornerRadius = 12
        box?.backgroundColor = UIColor(named: "colorLoadingBackground")
        containerView?.addSubview(box!)
        
        indicator = UIActivityIndicatorView()
        indicator?.center = mid
        indicator?.color = .red //UIColor(hex: "FBDC03")
        indicator?.hidesWhenStopped = true
        indicator?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        indicator?.startAnimating()
        containerView?.addSubview(indicator!)
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        window.addSubview(containerView!)
        
        isLoading = true
//        vc.view.addSubview(containerView!)
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.5) {
            self.indicator?.alpha = 0
            self.box?.alpha = 0
            self.containerView?.alpha = 0
        } completion: { _ in
            self.indicator?.stopAnimating()
            self.indicator?.removeFromSuperview()
            self.box?.removeFromSuperview()
            self.containerView?.removeFromSuperview()
        }
        isLoading = false
    }
    
}
