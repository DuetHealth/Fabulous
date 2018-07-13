//
//  FabulousAction.swift
//  Fabulous
//
//  Created by Ryan Wachowski on 7/5/18.
//  Copyright © 2018 Duet Health LLC. All rights reserved.
//

import Foundation
import UIKit

/// An action that can be taken when the user taps one of the fab's speed-dial controls.
///
/// You may use this class to customize the style and behavior triggered by a speed-dial action.
/// After customizing the action, add it to a `FabulousViewController` to include it in the fab's
/// shown speed-dial actions.
@objc public class FabulousAction: NSObject {

    /// The title of the action. If this value is `nil`, no title is shown.
    public let title: String?

    /// The image displayed on the action's control. If this value is `nil`, no image is shown.
    public let image: UIImage?

    /// The behavior of the action. This is executed when the action's control is tapped.
    public let handler: () -> ()

    /// Creates and returns a `FabulousAction` with the specified title, image, and behavior.
    @objc public init(title: String? = nil, image: UIImage? = nil, handler: @escaping () -> ()) {
        self.title = title
        self.image = image
        self.handler = handler
    }

}
