//
//  LineTableViewCell.swift
//  diff
//
//  Created by Ryan Farley on 8/9/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

class LineTableViewCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftLineNumberLabel: UILabel!
    @IBOutlet weak var rightLineNumberLabel: UILabel!
    
    @IBOutlet weak var leftLineNumberView: UIView!
    @IBOutlet weak var rightLineNumberView: UIView!
    
    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var rightLineLabel: UILabel!
    
    func configureCell(line: Line, fontSize: CGFloat) {
        leftLineNumberLabel.text = "\(line.lineNumbers.deleted)"
        rightLineNumberLabel.text = "\(line.lineNumbers.added)"
        
        leftLineLabel.text = line.content
        rightLineLabel.text = line.content
        
        setFontSize(fontSize: fontSize)
        setColorsForType(lineType: line.lineType)
    }
    
    private func setFontSize(fontSize: CGFloat) {
        leftLineNumberLabel.font = leftLineNumberLabel.font.withSize(fontSize)
        rightLineNumberLabel.font = rightLineNumberLabel.font.withSize(fontSize)
        
        leftLineLabel.font = leftLineLabel.font.withSize(fontSize)
        rightLineLabel.font = rightLineLabel.font.withSize(fontSize)
    }
    
    private func setColorsForType(lineType: LineType) {
        switch lineType {
        case .unchanged:
            leftView.backgroundColor = .clear
            rightView.backgroundColor = .clear
            leftLineNumberView.backgroundColor = .clear
            rightLineNumberView.backgroundColor = .clear
        case .addition:
            leftLineNumberLabel.text = ""
            leftLineLabel.text = ""
            leftView.backgroundColor = UIColor.Color.gray
            rightView.backgroundColor = UIColor.Color.lightGreen
            leftLineNumberView.backgroundColor = UIColor.Color.gray
            rightLineNumberView.backgroundColor = UIColor.Color.green
        case .deletion:
            rightLineNumberLabel.text = ""
            rightLineLabel.text = ""
            rightView.backgroundColor = UIColor.Color.gray
            leftView.backgroundColor = UIColor.Color.lightRed
            rightLineNumberView.backgroundColor = UIColor.Color.gray
            leftLineNumberView.backgroundColor = UIColor.Color.red
        }
    }
}
