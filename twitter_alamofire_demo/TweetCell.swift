//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyLabel: UIImageView!
    @IBOutlet weak var retweetLabel: UIImageView!
    @IBOutlet weak var favoriteLabel: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.name
            handleLabel.text = "@\(tweet.user.handle)"
            timeLabel.text = tweet.createdAtString
            favoriteLabel.isUserInteractionEnabled = true
            retweetLabel.isUserInteractionEnabled = true
            if (tweet.favorited == true) {
                favoriteLabel.image = #imageLiteral(resourceName: "favor-icon-red")
            }
            else {
                favoriteLabel.image = #imageLiteral(resourceName: "favor-icon")
            }
            if (tweet.retweeted == true) {
                retweetLabel.image = #imageLiteral(resourceName: "retweet-icon-green")
            }
            else {
                retweetLabel.image = #imageLiteral(resourceName: "retweet-icon")
            }
            retweetLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retweetPost)))
            favoriteLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoritePost)))
            userImage.af_setImage(withURL: URL(string: tweet.userImage)!)
            userImage.layer.cornerRadius = 16
            userImage.clipsToBounds = true
        }
    }
    
    @objc func retweetPost() {
        if tweet.retweeted {
            retweetLabel.isUserInteractionEnabled = false
            APIManager.shared.unretweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetLabel.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetLabel.isUserInteractionEnabled = true
                }
            })
            retweetLabel.image = #imageLiteral(resourceName: "retweet-icon")
        } else {
            retweetLabel.isUserInteractionEnabled = false
            APIManager.shared.retweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.retweetLabel.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetLabel.isUserInteractionEnabled = true
                    //self.delegate?.did(post: tweet!)
                }
            })
            retweetLabel.image = #imageLiteral(resourceName: "retweet-icon-green")
        }
    }
    
    @objc func favoritePost() {
        favoriteLabel.isUserInteractionEnabled = false
        if let favorited = tweet.favorited {
            if favorited {
                APIManager.shared.unfavoriteTweet(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
                favoriteLabel.image = #imageLiteral(resourceName: "favor-icon")
            } else {
                APIManager.shared.favoriteTweet(tweet, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        self.tweet = tweet
                    }
                })
                favoriteLabel.image = #imageLiteral(resourceName: "favor-icon-red")
            }
        } else {
            APIManager.shared.favoriteTweet(tweet, completion: { (tweet, error) in
                if let error = error {
                    self.favoriteLabel.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.favoriteLabel.isUserInteractionEnabled = true
                    self.tweet = tweet
                }
            })
            favoriteLabel.image = #imageLiteral(resourceName: "favor-icon-red")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
