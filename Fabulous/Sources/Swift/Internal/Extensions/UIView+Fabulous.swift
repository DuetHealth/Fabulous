import Foundation
import UIKit

extension UIView {

    func addHighShadow() {
        layer.shadowOffset = .highShadowOffset
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
    }

}
