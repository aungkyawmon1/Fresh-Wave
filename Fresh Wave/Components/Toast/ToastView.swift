//
//  ToastView.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/03/2024.
//

import UIKit

class ToastView: UIView {
    
    private lazy var lbMessage: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .white
        lb.numberOfLines = 0
        return lb
    } ()
    
    init(message: String,_ isSuccessfulSate: Bool) {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        
        var safeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            let hasNotch = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
            if hasNotch { safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 }
        }
        
        let attribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        let width: CGFloat = screenWidth - 36
        let messageHeight: CGFloat = message.heightWithConstrainedWidth(attributes: attribute, width: width - 44)
        let height: CGFloat = messageHeight + 32
        let frame = CGRect(x: 18, y: safeAreaHeight + 32, width: width, height: height)
        
        super.init(frame: frame)
        self.initView(with: message, isSuccessfulSate)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView(with message: String,_ isSuccessfulState: Bool) {
        lbMessage.text = message
        addSubview(lbMessage)
        
        NSLayoutConstraint.activate([
            lbMessage.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            lbMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            lbMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            lbMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
        
        tag = 1000
        backgroundColor = isSuccessfulState ? .successColor : .errorColor
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 4
    }
    
    func present() {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        if let _ = window.subviews.filter({ $0.tag == 1000 }).first { return }
        window.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.25) { self.alpha = 1 }
        Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { _ in
            UIView.animate(withDuration: 0.5) { self.alpha = 0 } completion: { _ in self.removeFromSuperview() }
        }
    }
    
}

extension ToastView {
    /// Show toast message
    ///
    /// - Parameters:
    ///     - message: the content of the toast message to show
    ///     - isSuccessfulState: it will show green background color if it is true or show red background color if it is not
    ///
    static func show(_ message: String, isSuccessfulState: Bool) {
        let toast = ToastView(message: message, isSuccessfulState)
        toast.present()
    }
}
