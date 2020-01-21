//
//  GYHUDSuccessView.swift
//  GYHUD
//
//  Created by CityFruit-GY on 2020/1/20.
//

import UIKit

class GYHUDSuccessView: UIView {

    var checkmarkShapeLayer: CAShapeLayer = {
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: 2.0, y: 13.5))
        checkmarkPath.addLine(to: CGPoint(x: 17.0, y: 28.0))
        checkmarkPath.addLine(to: CGPoint(x: 44.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 1.5, y: 1.5, width: 44.0, height: 28.0)
        layer.path = checkmarkPath.cgPath

        #if swift(>=4.2)
        layer.fillMode    = .forwards
        layer.lineCap     = .round
        layer.lineJoin    = .round
        #else
        layer.fillMode    = CAMediaTimingFillMode.forwards
        layer.lineCap     = CAShapeLayerLineCap.round
        layer.lineJoin    = CAShapeLayerLineJoin.round
        #endif

        layer.fillColor   = nil
        layer.strokeColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).cgColor
        layer.lineWidth   = 3.0
        return layer
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 45.5, height: 29.5))
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = layer.position
        
        self.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.35) {
            self.stopAnimation()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = layer.position
    }

    open func startAnimation() {
        let checkmarkStrokeAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        checkmarkStrokeAnimation.values = [0, 1]
        checkmarkStrokeAnimation.keyTimes = [0, 1]
        checkmarkStrokeAnimation.duration = 0.35

        checkmarkShapeLayer.add(checkmarkStrokeAnimation, forKey: "checkmarkStrokeAnim")
    }

    open func stopAnimation() {
        checkmarkShapeLayer.removeAnimation(forKey: "checkmarkStrokeAnimation")
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 45.5, height: 34)
    }
    
}
