//
//  GYHUDLoadingView.swift
//  GYHUD
//
//  Created by CityFruit-GY on 2020/2/27.
//

import UIKit
import NVActivityIndicatorView

public typealias GYHUDLoadingType = NVActivityIndicatorType

class GYHUDLoadingView: UIView {

    init(frame: CGRect, type: NVActivityIndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil) {
        super.init(frame: frame)
        let loadingView = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        self.addSubview(loadingView)
        loadingView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    open override var intrinsicContentSize: CGSize {
        return self.frame.size
    }

}
