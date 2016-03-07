//
//  EventsViewController.swift
//  NSManchester
//
//  Created by Ross Butler on 29/01/2016.
//  Copyright © 2016 Ross Butler. All rights reserved.
//

import UIKit

class WhenViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView?
    var menuOptions: Array<MenuOption>
    
    // MARK: View lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        
        menuOptions = DataService().whenMenuOptions()
        
        super.init(coder: aDecoder)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name: NSMNetworkUpdateNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let selectedIndex = tableView?.indexPathForSelectedRow
        {
            tableView?.deselectRowAtIndexPath(selectedIndex, animated: true)
        }
    }
    
    deinit {
       // NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = menuOptions[indexPath.row].cellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath);
        
        if (indexPath.row + 1) % 1 == 0
        {
            cell.contentView.backgroundColor = UIColor(red: 238.0/255.0, green: 121.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        }
        if (indexPath.row + 1) % 2 == 0
        {
            cell.contentView.backgroundColor = UIColor(red: 192.0/255.0, green: 105.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        }
        if (indexPath.row + 1) % 3 == 0
        {
            cell.contentView.backgroundColor = UIColor(red: 239.0/255.0, green: 173.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        }
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.destinationViewController.isKindOfClass(EventViewController)
        {
            let destination = segue.destinationViewController as! EventViewController
            let indexPath = tableView?.indexPathForSelectedRow!
            
            
            destination.titleText = menuOptions[(tableView?.indexPathForSelectedRow?.row)!].title
            destination.menuOptions = DataService().eventMenuOptions((tableView?.indexPathForSelectedRow?.row)!)
            
            // Centralise colours
            var backgroundColour : UIColor
            if (indexPath!.row + 1) % 1 == 0
            {
                backgroundColour = UIColor(red: 238.0/255.0, green: 121.0/255.0, blue: 101.0/255.0, alpha: 1.0)
                destination.backgroundColour = backgroundColour
            }
            if (indexPath!.row + 1) % 2 == 0
            {
                backgroundColour = UIColor(red: 192.0/255.0, green: 105.0/255.0, blue: 155.0/255.0, alpha: 1.0)
                destination.backgroundColour = backgroundColour
            }
            if (indexPath!.row + 1) % 3 == 0
            {
                backgroundColour = UIColor(red: 239.0/255.0, green: 173.0/255.0, blue: 150.0/255.0, alpha: 1.0)
                destination.backgroundColour = backgroundColour
            }
        }
    }
    
    // Notifications
    
    @objc func reload(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.tableView?.reloadData()
        }
    }

}
