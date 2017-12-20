//
//  DynamicSizeViewController.swift
//  PresentrExample
//
//  Created by Max Bhuiyan on 20/12/17.
//  Copyright © 2017 danielozano. All rights reserved.
//

import UIKit

class DynamicSizeViewController: UIViewController {
    class Action {
        enum Style {
            case style1
            case style2
        }
        typealias ActionHandler = ((Action) -> Void)
        let title: String?
        let style: Style
        let handler: ActionHandler?
        
        init(title: String?, style: Style, handler: ActionHandler? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }
        @objc func invoke() {
            handler?(self)
        }
    }
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var actionStackView: UIStackView!
    private var actions: [Action] = []
    
    public var message: String? = nil
    public func addAction(_ action: Action) {
        actions.append(action)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        //actionStackView.removeAllArrangedSubviews()
        //actionStackView.addArrangedSubview(UIView())
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.containerView.round(corners: [.topLeft, .topRight], radius: 8)
//        UIView.animate(withDuration: 0.2) {
//            self.updateUI()
//        }
    }
    
    private func updateUI() {
        actionStackView.removeAllArrangedSubviews()
        
        messageLabel.text = self.message
        actions.map { action in
            let button = UIButton(type: .system)
            button.setTitle(action.title, for: .normal)
            button.titleLabel?.textColor = .blue
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48))
            button.addTarget(action, action: #selector(Action.invoke), for: .touchUpInside)
            return button
            }
            .forEach{ button in
                self.actionStackView.addArrangedSubview(button)
            }
    }
}

private extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

private extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
