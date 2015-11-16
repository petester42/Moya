import UIKit
import Moya

class ViewController: UITableViewController {
    var repos = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        downloadRepositories("ashfurrow")
    }

    // MARK: - API Stuff

    func downloadRepositories(username: String) {        
        GitHubProvider.request(.UserRepositories(username), completion: { result in
            
            func toNSArray(response: MoyaResponse) throws -> NSArray {
                if let json = try response.mapJSON() as? NSArray {
                    // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                   return json
                } else {
                    throw MoyaError.JSONMapping(response)
                }
            }
            
            do {
                let response = try result()
                self.repos = try toNSArray(response)
                self.tableView.reloadData()
            } catch {
                let message: String

                if let error = error as? CustomStringConvertible {
                    message = error.description
                } else {
                    message = "Unable to fetch from GitHub"
                }
                
                let alertController = UIAlertController(title: "GitHub Fetch", message: message, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }

    func downloadZen() {
        GitHubProvider.request(.Zen, completion: { result in
            
            var message: String

            do {
                let response = try result()
                message = try response.mapString()
            } catch {
                message = "Couldn't access API"
            }
        
            let alertController = UIAlertController(title: "Zen", message: message, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }

    // MARK: - User Interaction

    @IBAction func searchWasPressed(sender: UIBarButtonItem) {
        var usernameTextField: UITextField?

        let promptController = UIAlertController(title: "Username", message: nil, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            if let usernameTextField = usernameTextField {
                self.downloadRepositories(usernameTextField.text!)
            }
        })
        _ = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        promptController.addAction(ok)
        promptController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            usernameTextField = textField
        }
        presentViewController(promptController, animated: true, completion: nil)
    }

    @IBAction func zenWasPressed(sender: UIBarButtonItem) {
        downloadZen()
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = repos[indexPath.row] as! NSDictionary
        (cell.textLabel as UILabel!).text = object["name"] as? String
        return cell
    }
}

