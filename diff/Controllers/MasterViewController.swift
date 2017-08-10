//
//  MasterViewController.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    lazy var formatter: DateFormatter = {
        return DateFormatter()
    }()
    
    var detailViewController: DetailViewController? = nil
    var pullRequests = [PullRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        fetchPulls()
    }
    
    func fetchPulls() {
        Service().load(resource: PullRequest.all) { result in
            switch result {
            case .success(let pullRequests):
                self.pullRequests = pullRequests
                self.tableView.reloadData()
            case .failure(let error):
                self.showFetchAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showFetchAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.fetchPulls()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Segues
extension MasterViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let pullRequest = pullRequests[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.pullRequest = pullRequest
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

// MARK: - Table View
extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PullRequestTableViewCell
        
        let pullRequest = pullRequests[indexPath.row]
        cell.configureCell(pullRequest: pullRequest, formatter: formatter)
        return cell
    }
}
