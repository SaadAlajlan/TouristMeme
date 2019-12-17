//
//  TabBarImagesViewController.swift
//  TouristMeme
//
//  Created by Saad on 12/16/19.
//  Copyright © 2019 saad. All rights reserved.
//

import Foundation
import UIKit

class TabBarImagesViewController: UITabBarController{
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBAction func action(_ sender: UIBarButtonItem) {
    
        if sender == mapButton{
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController!.pushViewController(detailController, animated: true)
            
        }else if sender == addButton{
                 let storyboard = UIStoryboard (name: "Main", bundle: nil)
                 let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
                 navigationController!.pushViewController(resultVC, animated: true)
                 self.tabBarController?.tabBar.isHidden = true
                 
                 
            
        }
 
    }
    
}
