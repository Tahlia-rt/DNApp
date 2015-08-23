//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, MenuViewControllerDelegate {

    let transitionManager = TransitionManager()
    var stories: JSON! = []
    var isFirstTime = true
    var section = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStories(section, page: 1)
        refreshControl?.addTarget(self, action: "refreshStories", forControlEvents: .ValueChanged)

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }

    func loadStories(section: String, page: Int) {
        DNService.storiesForSection(section, page: page) { (JSON) -> () in
            self.stories = JSON["stories"]
            self.tableView.reloadData()
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        }
    }

    func refreshStories() {
        loadStories(section, page: 1)
    }

// MARK: MenuViewControllerDelegate

    func menuViewControllerDidTouchTop(controller: MenuViewController) {
        view.showLoading()
        section = ""
        loadStories(section, page: 1)
        navigationItem.title = "Top Stories"
    }

    func menuViewControllerDidTouchRecent(controller: MenuViewController) {
        view.showLoading()
        section = "recent"
        loadStories(section, page: 1)
        navigationItem.title = "Recent Stories"
    }

// MARK: Actions

    @IBAction func menuButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("MenuSegue", sender: self)
    }

    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("LoginSegue", sender: self)
    }

// MARK: TableView Data Source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell", forIndexPath: indexPath) as! StoryTableViewCell

        let story = stories[indexPath.row]
        cell.configureWithStory(story)

        cell.delegate = self

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("WebSegue", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }

// MARK: StoryTableViewCellDelegate

    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject) {
        // TODO: Implement Upvote
    }

    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }

// MARK: Misc

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentsSegue" {
            let toViewController = segue.destinationViewController as! CommentsTableViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            toViewController.story = stories[indexPath.row]
        } else if segue.identifier == "WebSegue" {
            let toViewController = segue.destinationViewController as! WebViewController
            let indexPath = sender as! NSIndexPath
            let url = stories[indexPath.row]["url"].string!
            toViewController.url = url

            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
            toViewController.transitioningDelegate = transitionManager
        } else if segue.identifier == "MenuSegue" {
            let toViewController = segue.destinationViewController as! MenuViewController
            toViewController.delegate = self
        }
    }
}
