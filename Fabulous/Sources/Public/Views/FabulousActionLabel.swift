//
//  FabulousActionLabel.swift
//  Fabulous
//
//  Created by Ryan Wachowski on 7/5/18.
//  Copyright © 2018 Duet Health LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public class FabulousActionLabel: UILabel {

    public override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        let width = contentSize.width + contentInsets.left + contentInsets.right
        let height = contentSize.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }

    private let contentInsets = UIEdgeInsets.standardTextInsets

    init() {
        super.init(frame: .zero)
        textAlignment = .center
        clipsToBounds = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        superview?.layer.cornerRadius = bounds.height / 2
        layer.cornerRadius = bounds.height / 2
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentInsets))
    }

    /// Workaround for odd behavior when attempting to use base class appearance selectors.
    @objc public dynamic func setTextColor(to color: UIColor) {
        self.textColor = color
    }

    /// Workaround for odd behavior when attempting to use base class appearance selectors.
    @objc public dynamic func setBackgroundColor(to color: UIColor) {
        self.backgroundColor = color
    }

}


