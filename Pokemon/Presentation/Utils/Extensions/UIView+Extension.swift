//
//  UIView+Extension.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

extension UIView {
    // MARK: - Shadow
    
    func applyShadow(color: UIColor = UIColor.black.withAlphaComponent(0.12),
                     x: CGFloat = 0,
                     y: CGFloat = 2,
                     blur: CGFloat = 5) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur
    }
    
    // MARK: - Constraint
    
    @discardableResult
    func addRatioConstraint(multiplayer: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: multiplayer, constant: 0)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    func pinEdgesToSuperView(xMargin: CGFloat = 0, yMargin: CGFloat = 0) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: yMargin).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor, constant: xMargin).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -xMargin).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -yMargin).isActive = true
    }

    func pinCenterToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
    }

    func pinEdgesToSuperViewSafeXMargin(xMargin: CGFloat = 0, yMargin: CGFloat = 0) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor, constant: yMargin).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -yMargin).isActive = true
        leftAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leftAnchor, constant: xMargin).isActive = true
        rightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.rightAnchor, constant: -xMargin).isActive = true
    }
    
    // MARK: - Show/Hide
    func show(animation: Bool, animationDuration: Double = 0.25, completion: (() -> Void)? = nil) {

        guard alpha == 0 || isHidden else {
            completion?()
            return
        }
        alpha = 0
        isHidden = false
        if animation {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 1
            }) { (_) in
                completion?()
            }
        } else {
            alpha = 1
            completion?()
        }
    }

    func hide(animation: Bool, animationDuration: Double = 0.25, completion: (() -> Void)? = nil) {

        guard alpha != 0 || !isHidden else {
            completion?()
            return
        }
        if animation {
            UIView.animate(withDuration: animationDuration, animations: {
                self.alpha = 0
            }) { (_) in
                self.isHidden = true
                completion?()
            }
        } else {
            alpha = 0
            isHidden = true
            completion?()
        }
    }
}
