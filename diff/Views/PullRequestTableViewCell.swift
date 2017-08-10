//
//  PullRequestTableViewCell.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {

    func configureCell(pullRequest: PullRequest, formatter: DateFormatter) {
        textLabel!.text = pullRequest.title
        
        let dateString = formattedDate(dateString: pullRequest.createdAt, formatter: formatter)
        detailTextLabel!.text = "#\(pullRequest.number) opened on \(dateString) by \(pullRequest.author)"
    }
    
    private func formattedDate(dateString: String, formatter: DateFormatter) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = formatter.date(from: dateString)
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: dateObj!)
    }
}
