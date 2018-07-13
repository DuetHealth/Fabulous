import Foundation

extension UIView {

    func addHighShadow() {
        layer.shadowOffset = .highShadowOffset
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
    }

}
