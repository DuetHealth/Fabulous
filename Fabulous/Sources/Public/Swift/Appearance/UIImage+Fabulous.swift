//
//  UIImage+Fabulous.swift
//  ADMozaicCollectionViewLayout
//
//  Created by Ryan Wachowski on 7/5/18.
//

import Foundation
import UIKit

@objc public extension UIImage {

    /// Returns the fab's default plus image.
    static var fabulousDefaultAddImage: UIImage? {
        return UIImage(named: "fab-default-add", in: Bundle(for: FabulousViewController.self), compatibleWith: nil)
    }

}
