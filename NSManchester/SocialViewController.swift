//
//  SocialViewController.swift
//  NSManchester
//
//  Created by Ross Butler on 30/01/2016.
//  Copyright © 2016 Ross Butler. All rights reserved.
//

import UIKit
import SafariServices

class SocialViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var menuOptions: Array<MenuOption>
    
    // MARK: View lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        menuOptions = DataService().socialMenuOptions()
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name: NSMNetworkUpdateNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let selectedIndex = tableView.indexPathForSelectedRow
        {
            tableView.deselectRowAtIndexPath(selectedIndex, animated: true)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = menuOptions[indexPath.row].cellIdentifier
        let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath);
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let urlScheme = menuOptions[indexPath.row].urlScheme
        {
            if(UIApplication.sharedApplication().canOpenURL(NSURL(string:urlScheme)!))
            {
                UIApplication.sharedApplication().openURL(NSURL(string:urlScheme)!)
            } else {
                let safariViewController = SFSafariViewController(URL: NSURL(string: menuOptions[indexPath.row].subtitle!)!)
                self.presentViewController(safariViewController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    // Notifications
    
    @objc func reload(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.tableView.reloadData()
        }
    }
}