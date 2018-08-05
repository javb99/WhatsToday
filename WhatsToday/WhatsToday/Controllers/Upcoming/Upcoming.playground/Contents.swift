//: A playground to design and showcase the UpcomingViewController.
  
import UIKit
import PlaygroundSupport

class UpcomingViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension UpcomingViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandardEvent") else { fatalError() }
        
        
        return cell
    }
    
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UpcomingViewController()
