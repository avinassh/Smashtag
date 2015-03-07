//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by avi on 05/03/15.
//  Copyright (c) 2015 avi. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil

        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
        tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
        }

        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = NSData(contentsOfURL: profileImageURL) {
                // blocks main thread!
                tweetProfileImageView?.image = UIImage(data: imageData)
            } 
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
