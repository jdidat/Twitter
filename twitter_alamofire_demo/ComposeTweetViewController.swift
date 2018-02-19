//
//  ComposeTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jackson Didat on 2/18/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ComposeTweetViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var newTweet: UITextView!
    
    var delegate: ComposeTweetViewControllerDelegate?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            username.text = user.name
            handle.text = "@\(String(describing: user.handle))"
            userImage.af_setImage(withURL: URL(string: user.profileImageURL)!)
            userImage.layer.cornerRadius = 16
            userImage.clipsToBounds = true
        }
        newTweet.delegate = self
        newTweet.text = "What's going on?"
        newTweet.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postTweet(_ sender: Any) {
        APIManager.shared.composeTweet(with: newTweet.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newTweet.textColor == UIColor.lightGray {
            newTweet.text = nil
            newTweet.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = newTweet.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        characterCount.text = "\(140 - updatedText.count)"
        return updatedText.count < 140 // Change limit based on your requirement.
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
