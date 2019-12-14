//
//  MemesDetailViewController.swift
//  TouristMeme
//
//  Created by Saad on 12/13/19.
//  Copyright © 2019 saad. All rights reserved.
//

import Foundation

import Foundation
import UIKit

// MARK: - : UIViewController

class MemeDetailViewController: UIViewController {

    // MARK: Properties
    
    var memed: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!

    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
         imageView.sizeThatFits(view.frame.size)
        self.imageView!.image = memed.meamedImage
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
