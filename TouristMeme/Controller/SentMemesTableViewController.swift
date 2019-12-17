//
//  SentMemeTableViewController.swift
//  TouristMeme
//
//  Created by Saad on 12/13/19.
//  Copyright © 2019 saad. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController:  UITableViewController {
    
     var memes: [Meme]! {
          let object = UIApplication.shared.delegate
          let appDelegate = object as! AppDelegate
          return appDelegate.memes
      }
      
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
           self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
     
        tableView!.reloadData()
        
    }
    
       @objc func addTapped() {

           let storyboard = UIStoryboard (name: "Main", bundle: nil)
           let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
           navigationController!.pushViewController(resultVC, animated: true)
        self.tabBarController?.tabBar.isHidden = true



    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return memes.count
       }

    
       // cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
           let cell = tableView.dequeueReusableCell(withIdentifier: "memesCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
         
        
        cell.imageView?.image = meme.meamedImage
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText
        

           return cell

       }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
               detailController.memed = memes[(indexPath as NSIndexPath).row]
                self.navigationController!.pushViewController(detailController, animated: true)
                    }
}



