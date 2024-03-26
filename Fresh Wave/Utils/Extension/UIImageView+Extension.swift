//
//  UIImageView+Extension.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 24/03/2024.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setWebImage(with urlString: String?) {
        guard let urlString = urlString else { return }
        let options: KingfisherOptionsInfo = [
            .transition(ImageTransition.fade(0.2)),
            .forceTransition,
            .cacheOriginalImage
        ]
        kf.setImage(with: URL(string: urlString), placeholder: nil, options: options, completionHandler: nil)
    }
}
