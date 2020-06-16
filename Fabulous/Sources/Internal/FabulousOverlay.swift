import Foundation
import UIKit

public class FabulousOverlay: UIControl {

    private let blurEffectView = UIVisualEffectView(effect: nil)

    /// Controls whether the underlying view is blurred during activity.
    ///
    /// The default value of this is `true`.
    public dynamic var usesBlurOverlay: Bool = true

    /// The blur style of the blur effect, when active.
    ///
    /// The default value of this is `.regular` or `.light` depending on availability.
    public dynamic var blurEffectStyle: UIBlurEffect.Style = {
        if #available(iOS 10.0, *) { return .regular }
        else { return .light }
    }() {
        didSet { blurEffect = UIBlurEffect(style: blurEffectStyle) }
    }

    var interceptingView = UIView?.none
    private var blurEffect: UIBlurEffect

    init() {
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        super.init(frame: .zero)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.isUserInteractionEnabled = false
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(active: Bool, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.blurEffectView.effect = active && self.usesBlurOverlay ? self.blurEffect : nil
        })
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isEnabled, let interceptingView = self.interceptingView else { return super.hitTest(point, with: event) }
        return interceptingView.convert(interceptingView.bounds, to: self).contains(point) ? interceptingView : super.hitTest(point, with: event)
    }

}
