//
//  PicCollectionViewControllerCell.swift
//  TouristMeme
//
//  Created by Saad on 12/13/19.
//  Copyright © 2019 saad. All rights reserved.
//
import UIKit

class PicCollectionViewControllerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var taskToCancelifCellIsReused: URLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
            
        }
    }
}
