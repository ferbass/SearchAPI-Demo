//
//  DetailViewController.swift
//  SearchAPIDemo
//
//  Created by Fernando Ribeiro on 8/25/15.
//  Copyright © 2015 Fernando Ribeiro. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreSpotlight


class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameDescriptionLabel: UILabel!
    @IBOutlet weak var avatarDescriptionImage: UIImageView!
    
    var hero: Hero? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let hero = self.hero {
            if let name = self.nameDescriptionLabel {
                name.text = hero.name
            }
            
            if let about = self.detailDescriptionLabel {
                about.text = hero.about
            }
            
            if let avatar = self.avatarDescriptionImage {
                avatar.image = UIImage(named: hero.avatar)
            }
            
            
            let activity = NSUserActivity(activityType: "com.ferbass.SearchAPIDemo.detail")
            activity.userInfo = ["name": hero.name, "about": hero.about, "avatar": hero.about]
            activity.title = hero.name
            var keywords = hero.about.componentsSeparatedByString(" ")
            keywords.append(hero.about)
            activity.keywords = Set(keywords)
            activity.eligibleForHandoff = false
            activity.eligibleForSearch = true
            activity.eligibleForPublicIndexing = true
            
            activity.becomeCurrent()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}