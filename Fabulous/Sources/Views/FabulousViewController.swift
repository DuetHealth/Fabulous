import Foundation
import UIKit

/// Manages the lifecycle and presentation of a floating action button ("fab").
///
/// Use this view controller to add an obvious mechanism for the primary action(s) of the associated view.
/// The fab supports a single action or multiple "speed-dial" actions.
open class FabulousViewController: UIViewController {

    /// The primary floating button which triggers state changes or the primary action.
    public let primaryButton = UIButton(type: .system)

    /// The primary action of the fab, if any.
    ///
    /// When the value of this is non-nil, the fab switches from a collection of speed-dial actions
    /// to a single, primary action. Set this to `nil` to return the fab to a set of speed-dial actions.
    /// If the fab is showing actions and this value is set to an action, the fab hides its actions.
    public var primaryAction = FabulousAction?.none {
        didSet {
            guard let action = primaryAction else {
                primaryButton.removeAction(for: .touchUpInside)
                primaryButton.addTarget(self, action: #selector(showActions), for: .touchUpInside)
                return
            }
            if isShowingActions { hideActions() }
            primaryButton.removeTarget(self, action: #selector(showActions), for: .touchUpInside)
            primaryButton.addAction(action, for: .touchUpInside)
        }
    }

    /// Returns the list of actions backing the fab.
    public private(set) var actions = [FabulousAction]()

    /// Returns whether the fab is currently hidden.
    public var isHidden: Bool {
        return overlay.alpha == 0
    }

    /// Returns whether the fab is currently showing its actions.
    public private(set) var isShowingActions = false

    private let overlay: FabulousOverlay

    private lazy var actionsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.primaryButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = 16
        return stackView
    }()

    /// Convenience accessor for common containment hierarchies:
    /// * An outermost `UITabBarController` containing a `UINavigationController` containing the parent
    /// * An outermost `UINavigationController` containing a `UITabBarController` containing the parent
    /// * A `UINavigationController` containing the parent
    /// * A `UITabBarController` containing the parent
    private var supportedContainerView: UIView? {
        return parent?.navigationController?.tabBarController?.view ??
            parent?.tabBarController?.navigationController?.view ??
            parent?.navigationController?.view ??
            parent?.tabBarController?.view ??
            parent?.view as UIView?
    }

    /// Creates and returns a new fab, automatically establishing a parent-child relationship with
    /// the underlying view controller.
    ///
    /// The view hierarchy of this instance is private. You should not attempt to modify the view
    /// hierarchy in any way; the behavior of doing so is undefined.
    public init(overlying viewController: UIViewController) {
        overlay = FabulousOverlay()
        super.init(nibName: nil, bundle: nil)

        viewController.addChild(self)
        didMove(toParent: viewController)
    }

    public convenience init(overlying viewController: UIViewController, _ builder: (FabulousViewController) -> ()) {
        self.init(overlying: viewController)
        builder(self)
    }

    deinit {
        overlay.removeFromSuperview()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false

        overlay.isEnabled = false
        overlay.addTarget(self, action: #selector(hideActions), for: .touchUpInside)

        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(actionsStackView)
        NSLayoutConstraint.activate([
            primaryButton.widthAnchor.constraint(equalToConstant: .buttonSize),
            primaryButton.heightAnchor.constraint(equalTo: primaryButton.widthAnchor)
        ])
        overlay.interceptingView = primaryButton

        primaryButton.setImage(.fabulousDefaultAddImage, for: .normal)
        primaryButton.imageEdgeInsets = .standardImageInsets
        primaryButton.addLowShadow()
        primaryButton.layer.cornerRadius = .buttonSize / 2
        primaryButton.addTarget(self, action: #selector(showActions), for: .touchUpInside)
    }

    open override func didMove(toParent parent: UIViewController?) {
        guard let parentView = parent?.view else {
            self.view.removeFromSuperview()
            overlay.removeFromSuperview()
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false

        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentView.topAnchor),
            view.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            view.rightAnchor.constraint(equalTo: parentView.rightAnchor)
        ])

        overlay.translatesAutoresizingMaskIntoConstraints = false
        if let supportedContainerView = self.supportedContainerView {
            addOverlayToContainer(view: supportedContainerView)
        } else {
            addOverlayToSelf()
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showFab()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        hideFab()
    }

    /// Adds the action to the end of the list of actions, returning the created views for customization.
    @discardableResult public func addAction(_ action: FabulousAction) -> FabulousActionViews {
        actions.append(action)
        let (generatedView, returnedViews) = generateViews(for: action)
        actionsStackView.insertArrangedSubview(generatedView, at: 0)
        return returnedViews
    }

    /// Inserts the action at the position in the list of actions, returning the created views for customization.
    @discardableResult public func insertAction(_ action: FabulousAction, at index: Int) -> FabulousActionViews {
        actions.insert(action, at: index)
        let subviewIndex = actionsStackView.arrangedSubviews.count - 1 - index
        let (generatedView, returnedViews) = generateViews(for: action)
        actionsStackView.insertArrangedSubview(generatedView, at: subviewIndex)
        return returnedViews
    }

    /// Inserts the action before the given action, returning the created views for customization.
    @discardableResult public func insertAction(_ action: FabulousAction, before other: FabulousAction) -> FabulousActionViews {
        let index = actions.firstIndex { $0.id == action.id } ?? 0
        return insertAction(action, at: index)
    }

    /// Inserts the action after the given action, returning the created views for customization.
    @discardableResult public func insertAction(_ action: FabulousAction, after other: FabulousAction) -> FabulousActionViews {
        let index = actions.firstIndex { $0.id == action.id }.map { $0 + 1 } ?? 0
        return insertAction(action, at: index)
    }

    /// Removes the action from the list of actions.
    public func removeAction(_ action: FabulousAction) {
        guard let index = actions.firstIndex(where: { $0.id == action.id }) else { return }
        actions.remove(at: index)
        let subview = actionsStackView.arrangedSubviews[actionsStackView.arrangedSubviews.count - 1 - index]
        actionsStackView.removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }

    public func hideFab() {
        guard overlay.alpha != 0 else { return }
        overlay.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.overlay.alpha = 0
        })
    }

    public func showFab() {
        if let supportedView = self.supportedContainerView {
            addOverlayToContainer(view: supportedView )
        } else {
            addOverlayToSelf()
        }
        guard overlay.alpha != 1 else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.overlay.alpha = 1
        })
    }

    private func addOverlayToSelf() {
        view.addSubview(overlay)

        let bottomAnchor: NSLayoutYAxisAnchor
        let rightAnchor: NSLayoutXAxisAnchor

        if #available(iOS 11.0, *) {
            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
            rightAnchor = view.safeAreaLayoutGuide.rightAnchor
        } else {
            bottomAnchor = bottomLayoutGuide.topAnchor
            rightAnchor = view.rightAnchor
        }

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.rightAnchor.constraint(equalTo: view.rightAnchor),

            actionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44),
            actionsStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }

    private func addOverlayToContainer(view: UIView) {
        view.addSubview(overlay)

        let bottomAnchor: NSLayoutYAxisAnchor
        let rightAnchor: NSLayoutXAxisAnchor

        if #available(iOS 11.0, *) {
            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
            rightAnchor = view.safeAreaLayoutGuide.rightAnchor
        } else {
            bottomAnchor = view.bottomAnchor
            rightAnchor = view.rightAnchor
        }

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.rightAnchor.constraint(equalTo: view.rightAnchor),

            actionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44),
            actionsStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }

    private func generateViews(for action: FabulousAction) -> (UIView, FabulousActionViews) {
        let actionButton = UIButton(type: .system)
        actionButton.layer.cornerRadius = .buttonSize / 2
        actionButton.addHighShadow()
        actionButton.imageEdgeInsets = .standardImageInsets
        actionButton.setImage(action.image, for: .normal)
        actionButton.addAction(action, for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(hideActions), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: .buttonSize),
            actionButton.heightAnchor.constraint(equalTo: actionButton.widthAnchor)
        ])

        let arrangedSubviews: [UIView]
        let views: FabulousActionViews
        if let title = action.title {
            let shadowView = UIView()
            shadowView.addHighShadow()

            let actionLabel = FabulousActionLabel()
            actionLabel.translatesAutoresizingMaskIntoConstraints = false
            actionLabel.text = title
            shadowView.addSubview(actionLabel)
            NSLayoutConstraint.activate([
                actionLabel.topAnchor.constraint(equalTo: shadowView.topAnchor),
                actionLabel.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
                actionLabel.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
                actionLabel.rightAnchor.constraint(equalTo: shadowView.rightAnchor)
            ])

            arrangedSubviews = [shadowView, actionButton]
            views = FabulousActionViews(actionButton, actionLabel)
        } else {
            arrangedSubviews = [actionButton]
            views = FabulousActionViews(actionButton)
        }

        let newActionStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        newActionStackView.spacing = 24
        newActionStackView.alignment = .center
        newActionStackView.alpha = 0

        return (newActionStackView, views)
    }

    @objc private func showActions() {
        isShowingActions = true
        overlay.isEnabled = true
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.primaryButton.transform = CGAffineTransform(scaleX: 1.025, y: 1.025).rotated(by: .pi / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.primaryButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05).rotated(by: .pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.primaryButton.transform = CGAffineTransform(scaleX: 1.075, y: 1.075).rotated(by: 3 * .pi / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1, animations: {
                self.primaryButton.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1).rotated(by: 7 * .pi / 4)
            })
        })

        primaryButton.animateToHighShadow()
        overlay.animate(active: true, duration: 0.5)

        self.actionsStackView.arrangedSubviews.dropLast()
            .reversed()
            .compactMap { $0 as? UIStackView }
            .enumerated()
            .forEach { (offset, action) in
                let label = action.arrangedSubviews[0]
                let button = action.arrangedSubviews[1]
                label.transform = CGAffineTransform(translationX: label.bounds.width / 2, y: 0)
                button.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.25, delay: Double(offset) * 0.25 / 2, options: .curveEaseOut, animations: {
                    action.alpha = 1
                    label.transform = .identity
                })
                UIView.animate(withDuration: 0.25, delay: Double(offset) * 0.25 / 2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }

        primaryButton.removeTarget(self, action: #selector(showActions), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(hideActions), for: .touchUpInside)
    }

    @objc private func hideActions() {
        overlay.isEnabled = false
        isShowingActions = false
        UIView.animate(withDuration: 0.2, animations: {
            self.primaryButton.transform = .identity
            self.actionsStackView.arrangedSubviews.dropLast()
                .forEach { $0.alpha = 0 }
        })
        overlay.animate(active: false, duration: 0.2)
        primaryButton.animateToLowShadow()
        primaryButton.removeTarget(self, action: #selector(hideActions), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(showActions), for: .touchUpInside)
    }

}
