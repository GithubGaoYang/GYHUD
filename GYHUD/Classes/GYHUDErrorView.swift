//
//  GYHUDErrorView.swift
//  GYHUD
//
//  Created by CityFruit-GY on 2020/1/20.
//

import UIKit

class GYHUDErrorView: UIView {

    var dashOneLayer = GYHUDErrorView.generateDashLayer()
    var dashTwoLayer = GYHUDErrorView.generateDashLayer()

    class func generateDashLayer() -> CAShapeLayer {
        let dash = CAShapeLayer()
        dash.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        dash.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 22.0))
            path.addLine(to: CGPoint(x: 44.0, y: 22.0))
            return path.cgPath
        }()

        #if swift(>=4.2)
        dash.lineCap     = .round
        dash.lineJoin    = .round
        dash.fillMode    = .forwards
        #else
        dash.lineCap     = CAShapeLayerLineCap.round
        dash.lineJoin    = CAShapeLayerLineJoin.round
        dash.fillMode    = CAMediaTimingFillMode.forwards
        #endif

        dash.fillColor   = nil
        dash.strokeColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).cgColor
        dash.lineWidth   = 3
        return dash
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 44.0, height: 50.0))
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        dashOneLayer.position = layer.position
        dashTwoLayer.position = layer.position
        
        self.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.35) {
            self.stopAnimation()
        }

    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(dashOneLayer)
        layer.addSublayer(dashTwoLayer)
        dashOneLayer.position = layer.position
        dashTwoLayer.position = layer.position
    }

    func rotationAnimation(_ angle: CGFloat) -> CABasicAnimation {
        var animation: CABasicAnimation
        if #available(iOS 9.0, *) {
            let springAnimation = CASpringAnimation(keyPath: "transform.rotation.z")
            springAnimation.damping = 1.5
            springAnimation.mass = 0.22
            springAnimation.initialVelocity = 0.5
            animation = springAnimation
        } else {
            animation = CABasicAnimation(keyPath: "transform.rotation.z")
        }

        animation.fromValue = 0.0
        animation.toValue = angle * CGFloat(.pi / 180.0)
        animation.duration = 1.0

        #if swift(>=4.2)
        let timingFunctionName = CAMediaTimingFunctionName.easeInEaseOut
        #else
        let timingFunctionName = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.easeInEaseOut)
        #endif

        animation.timingFunction = CAMediaTimingFunction(name: convertToCAMediaTimingFunctionName(timingFunctionName.rawValue))
        return animation
    }

    public func startAnimation() {
        let dashOneAnimation = rotationAnimation(-45.0)
        let dashTwoAnimation = rotationAnimation(45.0)

        dashOneLayer.transform = CATransform3DMakeRotation(-45 * CGFloat(.pi / 180.0), 0.0, 0.0, 1.0)
        dashTwoLayer.transform = CATransform3DMakeRotation(45 * CGFloat(.pi / 180.0), 0.0, 0.0, 1.0)

        dashOneLayer.add(dashOneAnimation, forKey: "dashOneAnimation")
        dashTwoLayer.add(dashTwoAnimation, forKey: "dashTwoAnimation")
    }

    public func stopAnimation() {
        dashOneLayer.removeAnimation(forKey: "dashOneAnimation")
        dashTwoLayer.removeAnimation(forKey: "dashTwoAnimation")
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 44.0, height: 50.0)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCAMediaTimingFunctionName(_ input: CAMediaTimingFunctionName) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAMediaTimingFunctionName(_ input: String) -> CAMediaTimingFunctionName {
	return CAMediaTimingFunctionName(rawValue: input)
}
