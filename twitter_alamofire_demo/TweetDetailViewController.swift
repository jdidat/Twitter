//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jackson Didat on 2/17/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var numberOfRetweets: UILabel!
    @IBOutlet weak var numberOfFavorites: UILabel!
    @IBOutlet weak var replyLabel: UIImageView!
    @IBOutlet weak var retweetLabel: UIImageView!
    @IBOutlet weak var favoriteLabel: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            userImage.af_setImage(withURL: URL(string: tweet.userImage)!)
            username.text = tweet.user.name
            handle.text = "@\(tweet.user.handle)"
            tweetLabel.text = tweet.text
            favoriteLabel.isUserInteractionEnabled = true
            retweetLabel.isUserInteractionEnabled = true
            date.text = tweet.createdAtString
            numberOfRetweets.text = "\(String(tweet.retweetCount))" + " Retweets"
            numberOfFavorites.text = "\(String(describing: tweet.favoriteCount!))" + " Favorites"
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
        // Do any additional setup after loading the view.
    }
    
    @objc func retweetPost() {
        if (tweet?.retweeted)! {
            retweetLabel.isUserInteractionEnabled = false
            APIManager.shared.unretweet(tweet!, completion: { (tweet, error) in
                if let error = error {
                    self.retweetLabel.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetLabel.isUserInteractionEnabled = true
                    DispatchQueue.main.async {
                        self.tweet?.retweeted = false
                        self.retweetLabel.image = #imageLiteral(resourceName: "retweet-icon")
                    }
                }
            })
        } else {
            retweetLabel.isUserInteractionEnabled = false
            APIManager.shared.retweet(tweet!, completion: { (tweet, error) in
                if let error = error {
                    self.retweetLabel.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.retweetLabel.isUserInteractionEnabled = true
                    DispatchQueue.main.async {
                        self.tweet?.retweeted = true
                        self.retweetLabel.image = #imageLiteral(resourceName: "retweet-icon-green")
                    }
                }
            })
        }
    }
    
    @objc func favoritePost() {
        favoriteLabel.isUserInteractionEnabled = false
        if let favorited = tweet?.favorited {
            if favorited {
                APIManager.shared.unfavoriteTweet(tweet!, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        DispatchQueue.main.async {
                            self.tweet = tweet
                            self.favoriteLabel.image = #imageLiteral(resourceName: "favor-icon")
                        }
                    }
                })
            } else {
                APIManager.shared.favoriteTweet(tweet!, completion: { (tweet, error) in
                    if let error = error {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        print(error.localizedDescription)
                    } else {
                        self.favoriteLabel.isUserInteractionEnabled = true
                        DispatchQueue.main.async {
                            self.tweet = tweet
                            self.favoriteLabel.image = #imageLiteral(resourceName: "favor-icon-red")
                        }
                    }
                })
            }
        } else {
            APIManager.shared.favoriteTweet(tweet!, completion: { (tweet, error) in
                if let error = error {
                    self.favoriteLabel.isUserInteractionEnabled = true
                    print(error.localizedDescription)
                } else {
                    self.favoriteLabel.isUserInteractionEnabled = true
                    DispatchQueue.main.async {
                        self.tweet = tweet
                        self.favoriteLabel.image = #imageLiteral(resourceName: "favor-icon-red")
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
