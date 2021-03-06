//
//  GYHUD.swift
//  SunPeople
//
//  Created by CityFruit-GY on 2020/1/10.
//  Copyright © 2020 Beary Innovative Co., Ltd. All rights reserved.
//

import UIKit
import MBProgressHUD

public enum GYHUDType {
    case loading
    case loadingWith(type: GYHUDLoadingType, color: UIColor = UIColor.lightGray)
    case label
    case image(UIImage?)
    case success
    case error
}

public final class GYHUD {
    
    // MARK: Properties
    private static var _shared: MBProgressHUD?
    
    private static var minimumDismissTimeInterval: TimeInterval = 1 // default is 1.0 seconds
    private static var maximumDismissTimeInterval: TimeInterval = TimeInterval.greatestFiniteMagnitude // default is greatestFiniteMagnitude

    public static var shared: MBProgressHUD? {
        get {
            return _shared
        }
        set {
            _shared?.hide(animated: true)
            _shared = newValue
        }
    }

    private static var _defaultType: GYHUDType = .loadingWith(type: .ballRotateChase, color: UIColor.lightGray)

    public static var defaultType: GYHUDType {
        get {
            return _defaultType
        }
        set {
            _defaultType = newValue
        }
    }

    private static var _graceTime: TimeInterval? = nil

    public static var graceTime: TimeInterval {
        get {
            return _graceTime ?? GYHUD.shared?.graceTime ?? MBProgressHUD.init().graceTime
        }
        set {
            _graceTime = newValue
            GYHUD.shared?.graceTime = newValue
        }
    }
    
    private static var _bezelViewColor: UIColor? = UIColor.init(white: 0.5, alpha: 0.2)

    public static var bezelViewColor: UIColor? {
        get {
            return _bezelViewColor ?? GYHUD.shared?.bezelView.color ?? MBProgressHUD.init().bezelView.color
        }
        set {
            _bezelViewColor = newValue
            GYHUD.shared?.bezelView.color = newValue
        }
    }

    private static var _backgroundColor: UIColor? = UIColor.init(white: 0.5, alpha: 0.2)

    public static var backgroundColor: UIColor? {
        get {
            return _backgroundColor ?? GYHUD.shared?.backgroundView.color ?? MBProgressHUD.init().backgroundView.color
        }
        set {
            _backgroundColor = newValue
            GYHUD.shared?.backgroundView.color = newValue
        }
    }
    
    public static var dimsBackground: Bool {
        get {
            return (GYHUD.shared?.backgroundView.style == .some(.solidColor) && GYHUD.shared?.backgroundView.color == UIColor(white: 0, alpha: 0.1))
        }
        set {
            if newValue {
                GYHUD.shared?.backgroundView.style = .solidColor
                GYHUD.shared?.backgroundView.color = UIColor(white: 0, alpha: 0.1)
            } else {
                GYHUD.shared?.backgroundView.style = .blur
                
                if #available(iOS 13.0, *) {
                    // Leaving the color unassigned yields best results.
                    GYHUD.shared?.backgroundView.color = nil
                } else {
                    GYHUD.shared?.backgroundView.color = UIColor(white: 0.8, alpha: 0.6)
                }
            }
        }
    }

    public static var allowsInteraction: Bool {
        get { return !(GYHUD.shared?.isUserInteractionEnabled ?? false) }
        set { GYHUD.shared?.isUserInteractionEnabled = !newValue }
    }

    public static var isVisible: Bool { return GYHUD.shared?.superview != nil }

    // MARK: Public methods, PKHUD based
    public static func show(
        _ type: GYHUDType? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        onView view: UIView? = nil) {

        GYHUD.show(on: view)
                
        switch type ?? self.defaultType {
        case .loading:
            GYHUD.shared?.mode = .indeterminate
        case .label:
            GYHUD.shared?.mode = .text
        case .success:
            GYHUD.shared?.mode = .customView
            GYHUD.shared?.customView = GYHUDSuccessView()
        case .error:
            GYHUD.shared?.mode = .customView
            GYHUD.shared?.customView = GYHUDErrorView()
        case .image(let image):
            GYHUD.shared?.mode = .customView
            GYHUD.shared?.customView = UIImageView(image: image)
        case .loadingWith(type: let type, color: let color):
            GYHUD.shared?.mode = .customView
            GYHUD.shared?.customView = GYHUDLoadingView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: type, color: color, padding: nil)

        }
        
        GYHUD.shared?.label.text = title
        GYHUD.shared?.detailsLabel.text = subtitle
    }

    public static func hide(_ completion: (() -> Void)? = nil) {
        GYHUD.shared?.hide(animated: false)
        completion?()
    }

    public static func hide(animated: Bool, completion: (() -> Void)? = nil) {
        GYHUD.shared?.hide(animated: animated)
        completion?()
    }

    public static func hide(afterDelay delay: TimeInterval, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay) {
            GYHUD.shared?.hide(animated: true)
            completion?()
        }
    }

    // MARK: Public methods, HUD based
    public static func flash(
        _ type: GYHUDType,
        title: String?,
        subtitle: String? = nil,
        onView view: UIView? = nil) {
        GYHUD.show(type, title: title, subtitle: subtitle, onView: view)
        
        let length: TimeInterval = TimeInterval(max((title?.count ?? 0), (subtitle?.count ?? 0)))
        // 按照每分钟阅读700字（每0.086秒读一个字）计算
        let minimum = max(length * 0.086, GYHUD.minimumDismissTimeInterval)
        let displayDurationForString = min(minimum, GYHUD.maximumDismissTimeInterval)

        GYHUD.hide(afterDelay: displayDurationForString)
    }

    public static func flash(
        _ type: GYHUDType,
        title: String?,
        subtitle: String? = nil,
        onView view: UIView? = nil,
        delay: TimeInterval,
        completion: (() -> Void)? = nil) {
        GYHUD.show(type, title: title, subtitle: subtitle, onView: view)
        GYHUD.hide(afterDelay: delay, completion: completion)
    }
    
    // MARK: Keyboard Methods
//    public static func registerForKeyboardNotifications() {
//        PKHUD.sharedHUD.registerForKeyboardNotifications()
//    }
//
//    public static func deregisterFromKeyboardNotifications() {
//        PKHUD.sharedHUD.deregisterFromKeyboardNotifications()
//    }
    
}

private extension GYHUD {
    @discardableResult
    static func show(on view: UIView? = nil) -> MBProgressHUD? {
        
        guard let view = view ?? UIApplication.shared.keyWindow else {
            return nil
        }
        
        if GYHUD.shared?.superview != view {
            GYHUD.shared?.hide(animated: true)
        }
        GYHUD.shared = MBProgressHUD.init(view: view)
        GYHUD.shared?.removeFromSuperViewOnHide = true
        GYHUD.shared?.label.numberOfLines = 0
        GYHUD.shared?.detailsLabel.numberOfLines = 0
        GYHUD.shared?.graceTime = graceTime
        GYHUD.shared?.bezelView.color = bezelViewColor
        GYHUD.shared?.backgroundView.color = self.backgroundColor
        view.addSubview(GYHUD.shared!)
        GYHUD.shared?.show(animated: true)
        
        return GYHUD.shared

    }
}
