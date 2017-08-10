//
//  PopoverViewController.swift
//  diff
//
//  Created by Ryan Farley on 8/10/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

protocol PopoverViewControllerDelegate {
    func smallerButtonTapped()
    func largerButtonTapped()
}

class PopoverViewController: UIViewController {
    
    var delegate: PopoverViewControllerDelegate?
    
    @IBAction func smallerButtonTapped(_ sender: Any) {
        delegate?.smallerButtonTapped()
    }
    
    @IBAction func largerButtonTapped(_ sender: Any) {
        delegate?.largerButtonTapped()
    }
}
