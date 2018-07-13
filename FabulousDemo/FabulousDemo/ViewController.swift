import Fabulous
import UIKit

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.2039, green: 0.2471, blue: 0.2235, alpha: 1)

        navigationItem.title = "Bananas"

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 125
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bananas")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])

        FabulousViewController(overlying: self) { fab in
            fab.addAction(FabulousAction(title: "Find a banana", image: UIImage(named: "banana-action")) {
                print("Finding bananas...")
            })

            fab.addAction(FabulousAction(title: "Buy a banana", image: UIImage(named: "shop-action")) {
                print("Purchase confirmed. Your banana is on its way!")
            })
        }

    }

}

