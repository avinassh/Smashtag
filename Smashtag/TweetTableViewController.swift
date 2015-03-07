//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by avi on 03/03/15.
//  Copyright (c) 2015 avi. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    var searchText: String? = "#stanford" {
        didSet {
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
            // reset the lastSuccessfulRequest since the search text is changed
            // and it doesn't matter anymore
            lastSuccessfulRequest = nil
        }
    }
    // model of the project
    var tweets = [[Tweet]]()
    
    
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            // create a TwitterRequest and then fetch it
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    // following is mainly UI code. so better dispatch it back to main
                    // queue. Or else lots of bad things will happen 😨
                    dispatch_async(dispatch_get_main_queue()) {
                        if newTweets.count > 0 {
                            self.tweets.insert(newTweets, atIndex: 0)
                            // reloads the whole table instead we could reload only
                            // this section
                            self.tableView.reloadData()
                            // since this request is successul, so lets it to
                            // lastSuccessfulRequest
                            self.lastSuccessfulRequest = request
                        }
                        // stop the spinning wheel
                        sender?.endRefreshing()
                    }
                }
            }
        } else {
            // if search text is nil, lets stop is spinning.
            sender?.endRefreshing()
        }
    }
    
    private func refresh() {
        // even when we call this refresh() function from code, it will
        // still work
        // so lets spin it, when its called from the code
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        
        // using resizable custom cells
        // first lets give estimated row height, from storyboard
        tableView.estimatedRowHeight = tableView.rowHeight
        // now reset it's height and let it figure out by itself
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Text field delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            // make the keyboard hide/dissapear
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }

    
    private struct Storyboard {
        static let cellReuseIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
