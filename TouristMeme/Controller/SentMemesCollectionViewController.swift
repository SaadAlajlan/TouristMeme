//
//  SentMemeCollectionViewController.swift
//  TouristMeme
//
//  Created by Saad on 12/13/19.
//  Copyright © 2019 saad. All rights reserved.
//


import UIKit
import Foundation

class SentMemesCollectionViewController:  UICollectionViewController,  UICollectionViewDelegateFlowLayout {

      var memes: [Meme]! {
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          return appDelegate.memes
      }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

      // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        initLayout(size: view.frame.size)
    NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "refresh") , object: nil)
          }

          @objc func refreshTable() {
              collectionView.reloadData()
          }
    func initLayout(size: CGSize) {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        dimension = (size.width - (2 * space)) / 3.0
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        
       self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
     
        collectionView!.reloadData()
        
    }
    
    
    @IBAction func addTapped(_ sender : UIBarButtonItem) {
     
        if sender == addButton{
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        navigationController!.pushViewController(resultVC, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        }
        if sender == mapButton{
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            navigationController!.pushViewController(resultVC, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }
        

    }
    
      override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
      }
      
 
 

 
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        
   
    cell.ImageView?.image = meme.meamedImage
        
        
        return cell
    }
      
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
         
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memed = self.memes[(indexPath as NSIndexPath).row]
         self.navigationController!.pushViewController(detailController, animated: true)
         
     }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //TODO: Set the left and right spacing of a cell to be 2
        return UIEdgeInsets (top: 0, left: 2, bottom: 0, right: 2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //TODO: Set the columns to 2 and the rows to 2 in a rectangle area of the collection view (ususally the area visible on the secreen).
        
        let bounds = collectionView.bounds
        
        return CGSize(width: (bounds.width/2)-4 , height: bounds.height/2)
        
        
    }
    
}

