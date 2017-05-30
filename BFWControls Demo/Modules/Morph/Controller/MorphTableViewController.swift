//
//  MorphTableViewController.swift
//
//  Created by Tom Brodhurst-Hill on 27/10/2015.
//  Copyright © 2015 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit
import BFWControls

class MorphTableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let morphSegue = segue as? MorphSegue,
            let cell = sender as? UITableViewCell
        {
            morphSegue.fromView = cell;
        }
    }
    
}
