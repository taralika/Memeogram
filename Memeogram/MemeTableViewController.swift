//
//  MemeTableViewController.swift
//  Memeogram
//
//  Created by taralika on 5/15/19.
//  Copyright © 2019 at. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    @IBOutlet var memeTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTableView.rowHeight = CGFloat(140.0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.memeLabel?.text = "\(meme.topText)" + " " + "\(meme.bottomText)"
        cell.tableMemeImageView?.image = meme.memedImage
        
        return cell
    }
    
    // Prepare the sague to image viewer.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewMemeSegue" {
            let selectedMeme = sender as! Meme
            if let detailVC = segue.destination as? MemeDetailViewController {
                detailVC.meme = selectedMeme
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
        performSegue(withIdentifier: "viewMemeSegue", sender: selectedMeme)
    }
}
