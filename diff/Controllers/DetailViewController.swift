//
//  DetailViewController.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var pullRequest: PullRequest? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let pull = pullRequest {
            title = pull.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
