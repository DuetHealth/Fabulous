import Foundation
import UIKit

extension CGFloat {

    static var buttonSize: CGFloat = 56

}

extension CGSize {

    static var lowShadowOffset: CGSize {
        return CGSize(width: 0, height: 2)
    }

    static var highShadowOffset: CGSize {
        return CGSize(width: 0, height: 4)
    }

}

extension UIEdgeInsets {

    static var standardImageInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    static var standardTextInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

}
