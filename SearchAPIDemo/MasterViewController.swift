//
//  MasterViewController.swift
//  SearchAPIDemo
//
//  Created by Fernando Ribeiro on 8/25/15.
//  Copyright © 2015 Fernando Ribeiro. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

let heroActivityName = "com.ferbass.SearchAPIDemo.hero"
let heroSearchDomain = "com.ferbass.SearchAPIDemo.hero.search"

struct Hero {
    var name: String
    var about: String
    var avatar: String
    var id: NSUUID
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var heroes = [
        Hero(name: "Iron Man", about: "Iron Man, (real name Tony Stark), is the main hero of a comic by the same name. Stark: an inventive genius, industrialist, and multi-billionaire, went to Vietnam to oversee a field test for one of his transistorized weapons, that his company-Stark Industries made. While there he accidentally stepped on a bobby trap, and a piece of shrapnel became lodged in his chest. Injured, Stark was captured by Communist forces under Wong-Chu, and made a prisoner. While in prison, Tony created a mechanical suit of armor so that he could escape, as well as using his technological know-how to create a pace-maker like device to keep his heart beating and thus, Stark could stay alive. Using the Iron Suit, Stark was able to escape the Communist forces, and once back in America, he perfected his work, making a practically invincible iron suit much like he has today.", avatar: "ironman",id: NSUUID()),
        Hero(name: "Captain America", about: "Captain America is a superhero from Marvel comics who fought against the Red Skull during WWII as part of a secret super-soldier experiment - he was revived in the modern age by the Avengers and became their leader as a champion of the ideals of truth, justice and the American way.", avatar: "cap",id: NSUUID()),
        Hero(name: "Batman", about: "Batman is the titular primary protagonist of the Batman comics, cartoon, movies and video games. After experiencing the horrifying death of his parents at a young age, Bruce Wayne travels across the world learning different martial arts. When he came back to Gotham City, he started as a vigilante who will be later known as the legendary Batman.", avatar: "batman",id: NSUUID()),
        Hero(name: "Thor", about: "Thor Odinson (a.k.a. \"The Mighty Thor\") is the Asgardian prince of Asgard and the Norse God of thunder. He is the son of Odin and Gaea, as well as the brother of Loki, Baldr and many more siblings. He is also the lover of the mortal known as Jane Foster and the friend of Lady Sif, Hogun, Fandril and Volstagg.", avatar: "thor",id: NSUUID()),
        Hero(name: "Hulk", about: "Ultimate Marvel Hulk is much different from the normal Hulk, he usually tends to cause harm to innocents. But he does act in a heroic manner once in a while and helps out whenever he's really needed. And despite his sadism he does regret his actions once in a while. This version of Bruce Banner is also very complicated, as he is very abusive towards Betty and has caused harm to millions of people. But even Banner has his limits, as he has shown regret for many of his actions in the past.", avatar: "hulk",id: NSUUID()),
        Hero(name: "Hawkeye", about: "Clinton Francis Barton AKA Hawkeye, is a member of the Avengers and is known for his amazing skills in archery - often deploying a number of trick arrows to deal with his opponents - he is also a rebel of sorts who often clashes with Captain America over differences in opinions, although he won't let his dislike of certain rules or individuals stop him from defending what he sees as right.", avatar: "hawkeye",id: NSUUID()),
        Hero(name: "Wolverine", about: "Wolverine was a mutant whose primary ability was an accelerated healing factor that enabled him to regenerate damaged or destroyed bodily tissue with far greater speed and efficiency than an ordinary human. Wolverine's healing factor may have greatly retarded his aging. Wolverine's entire skeleton was infused with a rare, artificially created alloy known asAdamantium. As a result, Wolverine's bones were rendered highly resistant to all forms of physical damage.", avatar: "wolverine",id: NSUUID())
    ]
    
    
    var heroToRestore: Hero?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        var searchableItems: [CSSearchableItem] = []
        
        for hero in heroes {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            
            attributeSet.title = hero.name
            
            attributeSet.contentDescription = hero.about
            
            attributeSet.keywords = [hero.name, "Heroes", "Mavel", "DC", "Comics", "Stan lee"]
                        
            if let thumbnail = UIImage(named: hero.avatar) {
                attributeSet.thumbnailData = UIImageJPEGRepresentation(thumbnail, 1)
            }
            
            let item = CSSearchableItem(uniqueIdentifier: hero.name, domainIdentifier: heroSearchDomain, attributeSet: attributeSet)
            searchableItems.append(item)
        }
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                print("Hero indexing successful")
            }
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let hero = heroes[indexPath.row] 
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.hero = hero
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }else{
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.hero = self.heroToRestore
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let hero = heroes[indexPath.row]
        
        cell.textLabel!.text = hero.name
        cell.detailTextLabel!.text = hero.about
        cell.detailTextLabel!.numberOfLines = 3
        cell.imageView!.image = UIImage(named: hero.avatar)
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        if let name = activity.userInfo?["kCSSearchableItemActivityIdentifier"] as? String {
            
            let hero = heroes.filter( { return $0.name == name } )
            self.heroToRestore = hero[0] as Hero
            self.performSegueWithIdentifier("showDetail", sender: self)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Error retrieving information from userInfo:\n\(activity.userInfo)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}