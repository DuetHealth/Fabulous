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
