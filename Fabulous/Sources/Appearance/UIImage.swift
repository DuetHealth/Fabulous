import Foundation
import UIKit

public extension UIImage {

    /// Returns the fab's default plus image.
    static var fabulousDefaultAddImage: UIImage? {
        return UIImage(named: "fab-default-add", in: Bundle(for: FabulousViewController.self), compatibleWith: nil)
    }

}
