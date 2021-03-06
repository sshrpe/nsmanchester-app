//
//  EventsViewController.swift
//  NSManchester
//
//  Created by Ross Butler on 29/01/2016.
//  Copyright © 2016 Ross Butler. All rights reserved.
//

import UIKit

class WhenViewController : UIViewController {
    
    @IBOutlet weak private var tableView: UITableView?
    lazy var menuOptions: [MenuOption] = {
        return DataService().whenMenuOptions()
    }()
    
    // MARK: View lifecycle
    override func viewWillAppear(animated: Bool) {
        if let selectedIndex = tableView?.indexPathForSelectedRow
        {
            tableView?.deselectRowAtIndexPath(selectedIndex, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController is EventViewController
        {
            let destination = segue.destinationViewController as! EventViewController
            let indexPath = tableView?.indexPathForSelectedRow!
            
            destination.titleText = menuOptions[(tableView?.indexPathForSelectedRow?.row)!].title
            destination.menuOptions = DataService().eventMenuOptions((tableView?.indexPathForSelectedRow?.row)!)
            
            // Centralise colours
            destination.backgroundColour = colorFor(indexPath!)
        }
    }
    
    private func colorFor(indexPath: NSIndexPath) -> UIColor {
        if (indexPath.row + 1) % 1 == 0
        {
            return UIColor.burntSiennaColor()
        }
        if (indexPath.row + 1) % 2 == 0
        {
            return UIColor.hopbushColor()
        }
        if (indexPath.row + 1) % 3 == 0
        {
            return UIColor.waxFlowerColor()
        }
        fatalError("wrong indexPath") // should never happen
    }
}

extension WhenViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = menuOptions[indexPath.row].cellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath);
        
        cell.contentView.backgroundColor = colorFor(indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row].title
        
        if let subtitle = menuOptions[indexPath.row].subtitle
        {
            cell.detailTextLabel?.text = subtitle
        }
        
        let selectedBackgroundView = UIView(frame: cell.frame)
        selectedBackgroundView.backgroundColor = tableView.cellSelectionColourForCellWithColour(cell.contentView.backgroundColor!)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
}

extension WhenViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
