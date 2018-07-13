# Fabulous

Fabulous is a material-inspired floating action button with a little Human Interface flair. Supports singular, primary actions or a collection of speed-dial actions.

<img src="https://github.com/DuetHealth/Fabulous/raw/master/Demo/demo.gif" width='187' alt="Demo">

## Usage

### Installation

Cocoapods: `pod 'Fabulous', '~> 1.0'`. See [Fabulous.podspec](Fabulous.podspec) for more information.

Carthage: `github "DuetHealth/Fabulous" ~> 1.0 && carthage update`

### Adding a fab

Adding a fab currently involves making modifications to the underlying view controller's view hierarchy, so you should ensure that the view has at least been loaded to begin using a fab. Actually installing the fab in the hierarchy is simple.

```swift
class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep a reference around (for reasons.)
        let fab = FabulousViewController(overlying: self)
        fab.addAction(FabulousAction(title: "Action 1", image: UIImage(named: "action-1")) {
            print("Fabulous!")
        })

        fab.addAction(FabulousAction(title: "Action 2", image: UIImage(named: "action-2")) {
            print("Marvelous!")
        })
    }

}
```

```swift
class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // No need for the reference? Use a builder-style constructor.
        FabulousViewController(overlying: self) { fab in
        
            fab.addAction(FabulousAction(title: "Action 1", image: UIImage(named: "action-1")) {
                print("Fabulous!")
            })

            fab.addAction(FabulousAction(title: "Action 2", image: UIImage(named: "action-2")) {
                print("Marvelous!")
            })

        }
    }

}
```

## License

Fabulous is MIT-licensed. The [MIT license](LICENSE) is included in the root of the repository.
