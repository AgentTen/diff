//
//  DetailViewController.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var files = [File]()
    
    var pullRequest: PullRequest? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        tableView.estimatedSectionHeaderHeight = 34
    }
    
    private func configureView() {
        if let pull = pullRequest {
            title = pull.title
            fetchFiles()
        }
    }
    
    func fetchFiles() {
        guard let pull = pullRequest else {
            return
        }
        Service().load(resource: File.all(pullNumber: pull.number)) { result in
            switch result {
            case .success(let files):
                self.files = files
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
            self.fetchFiles()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let file = files[section]
        return file.lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineCell", for: indexPath) as! LineTableViewCell
        
        let file = files[indexPath.section]
        let line = file.lines[indexPath.row]
        cell.configureCell(line: line)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! SectionHeaderViewCell
        cell.headerLabel.text = files[section].filename
        return cell
    }
}
