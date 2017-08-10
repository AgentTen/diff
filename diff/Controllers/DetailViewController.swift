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
        let dict: [String: Any] = [
            "filename": "filename",
            "status": "status",
            "additions": 2,
            "deletions": 3,
            "changes": 4,
            "patch": "these are a bunch of changes"
        ]
        
        if let file = File(json: dict) {
            files = [file, file, file]
        }
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
