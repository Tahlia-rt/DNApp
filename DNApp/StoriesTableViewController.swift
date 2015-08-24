//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 16/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, MenuViewControllerDelegate, LoginViewControllerDelegate {

    let transitionManager = TransitionManager()
    var stories: JSON! = []
    var isFirstTime = true
    var section = ""
    @IBOutlet weak var loginButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        loadStories(section, page: 1)
        refreshControl?.addTarget(self, action: "refreshStories", forControlEvents: .ValueChanged)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: .Normal)
        loginButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: .Normal)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }

    func loadStories(section: String, page: Int) {
        if LocalStore.getToken() == nil {
            loginButton.title = "Login"
            loginButton.enabled = true
        } else {
            loginButton.title = ""
            loginButton.enabled = false
        }

        DNService.storiesForSection(section, page: page) { (JSON) -> () in
            self.stories = JSON["stories"]
            self.tableView.reloadData()
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        }
    }

    func refreshStories() {
        SoundPlayer.play("refresh.wav")
        loadStories(section, page: 1)
    }

// MARK: LoginViewControllerDelegate

    func loginViewControllerDidLogin(controller: LoginViewController) {
        loadStories(section, page: 1)
        view.showLoading()
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

    func menuViewControllerDidTouchLogout(controller: MenuViewController) {
        view.showLoading()
        loadStories(section, page: 1)
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
        if let token = LocalStore.getToken() {
            let indexPath = tableView.indexPathForCell(cell)!
            let story = stories[indexPath.row]
            let storyId = story["id"].int!

            DNService.upvoteStoryWithId(storyId, token: token) { (successfull) -> () in
                print("success")
            }

            LocalStore.saveUpvotedStory(storyId)
            cell.configureWithStory(story)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
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
        } else if segue.identifier == "LoginSegue" {
            let toViewController = segue.destinationViewController as! LoginViewController
            toViewController.delegate = self
        }
    }
}
