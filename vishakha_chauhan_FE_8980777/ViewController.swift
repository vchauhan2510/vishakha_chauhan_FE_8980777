import UIKit
import CoreData

struct Grade: Codable {
    var subject: String
    var score: Double
}

class ViewController: UIViewController {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourAppName")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background
        let backgroundImageView = UIImageView(image: UIImage(named: "backgroundImage"))
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.25
        view.addSubview(backgroundImageView)
        
        // Your Picture
        let yourImageView = UIImageView(image: UIImage(named: "yourPicture"))
        yourImageView.frame = CGRect(x: 50, y: 150, width: 225, height: 175)
        yourImageView.contentMode = .scaleAspectFit
        yourImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yourImageView)
        
        // Constraints for Your Picture
        NSLayoutConstraint.activate([
            yourImageView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 35),
            yourImageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 35),
            view.trailingAnchor.constraint(greaterThanOrEqualTo: yourImageView.trailingAnchor, constant: 35),
            view.bottomAnchor.constraint(greaterThanOrEqualTo: yourImageView.bottomAnchor, constant: 35)
        ])
        
        // Navigation Button
        let navigateButton = UIButton(type: .system)
        navigateButton.setTitle("Navigate", for: .normal)
        navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigateButton)
        
        // Constraints for Navigation Button
        NSLayoutConstraint.activate([
            navigateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            navigateButton.widthAnchor.constraint(equalToConstant: 100),
            navigateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func navigateButtonTapped() {
        // Implement navigation logic here
    }
    
    func fetchDataFromServer() {
        guard let url = URL(string: "your_api_endpoint") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let parsedData = try decoder.decode(YourDataType.self, from: data)
                // Handle parsed data
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    struct YourDataType: Codable {
        // Define your properties here
    }
    
    class CustomTableViewCell: UITableViewCell {
        // Define your outlets here
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

