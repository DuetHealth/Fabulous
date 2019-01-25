import Foundation
import UIKit

fileprivate var fabulousActionKey: UInt8 = 0

extension UIButton {

    func addAction(_ action: FabulousAction, for controlEvents: UIControl.Event) {
        objc_setAssociatedObject(self, &fabulousActionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(triggerAction), for: controlEvents)
    }

    func removeAction(for controlEvents: UIControl.Event) {
        objc_setAssociatedObject(self, &fabulousActionKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.removeTarget(self, action: #selector(triggerAction), for: controlEvents)
    }

    @objc private func triggerAction() {
        guard let action = objc_getAssociatedObject(self, &fabulousActionKey) as? FabulousAction else { return }
        action.handler()
    }

    func addLowShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.black.cgColor
    }

    @objc func animateToLowShadow() {
        let offsetAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOffset))
        offsetAnimation.toValue = CGSize(width: 0, height: 2)
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
        opacityAnimation.toValue = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [offsetAnimation, opacityAnimation]
        animationGroup.duration = 0.2
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false

        layer.add(animationGroup, forKey: String(describing: #selector(animateToLowShadow)))
    }

    @objc func animateToHighShadow() {
        let offsetAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.shadowOffset))
        let arguments: [(CGFloat, Float)] = [(2, 0), (2.5, .pi / 2), (3, .pi), (3.5, 3 * .pi / 2), (4, 7 * .pi / 4)]
        offsetAnimation.values = arguments.map { CGSize(width: $0.0 * CGFloat(sinf($0.1)), height: $0.0 * CGFloat(cosf($0.1))) }
        offsetAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowOpacity))
        opacityAnimation.toValue = 0.3

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [offsetAnimation, opacityAnimation]
        animationGroup.duration = 0.4
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false

        layer.add(animationGroup, forKey: String(describing: #selector(animateToHighShadow)))
    }

}
