//
//  MemeDetailViewController.swift
//  Memeogram
//
//  Created by taralika on 5/15/19.
//  Copyright © 2019 at. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        memeImageView!.image = meme.memedImage
    }
}
