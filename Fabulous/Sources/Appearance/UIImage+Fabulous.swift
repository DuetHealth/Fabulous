import Foundation
import UIKit

public extension UIButton {

    static var appearanceContainedInFabulous: Self {
        appearance(whenContainedInInstancesOf: [FabulousOverlay.self])
    }

    static func appearanceContainedInFabulous(for traitCollection: UITraitCollection) -> Self {
        appearance(for: traitCollection, whenContainedInInstancesOf: [FabulousOverlay.self])
    }

}

public extension UIImage {

    /// Returns the fab's default plus image.
    static var fabulousDefaultAddImage: UIImage? {
        return UIImage(named: "fab-default-add", in: Bundle(for: FabulousViewController.self), compatibleWith: nil)
    }

}
