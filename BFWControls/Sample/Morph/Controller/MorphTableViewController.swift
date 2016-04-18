//
//  MorphTableViewController.swift
//
//  Created by Tom Brodhurst-Hill on 27/10/2015.
//  Copyright © 2015 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class MorphTableViewController: UITableViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let morphSegue = segue as? MorphSegue,
            let cell = sender as? UITableViewCell
        {
            morphSegue.fromView = cell;
        }
    }
    
}
