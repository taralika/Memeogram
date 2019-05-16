//
//  MemeCollectionViewController.swift
//  Memeogram
//
//  Created by taralika on 5/15/19.
//  Copyright © 2019 at. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.collectionMemeImageView?.image = meme.memedImage
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewMemeSegue" {
            let selectedMeme = sender as! Meme
            if let detailVC = segue.destination as? MemeDetailViewController {
                detailVC.meme = selectedMeme
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.item]
        performSegue(withIdentifier: "viewMemeSegue", sender: selectedMeme)
    }
}
