//
//  ViewController.swift
//  GifDemo
//
//  Created by omsairam on 25/02/22.
//

import UIKit

class GifSearcherVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
            didSet {
              //  collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.layer.borderWidth = 1.0
    }


}

// MARK: - Collection view delegate and data source methods
extension GifSearcherVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseID, for: indexPath) as! GifCollectionViewCell
        
        cell.layer.borderWidth = Constants.borderWidth
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.maxWidth = collectionView.bounds.width - Constants.spacing
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.red.cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.imageView.layer.borderWidth = 0.5
        cell.imageView.layer.borderColor = UIColor.green.cgColor
        return cell
    }
}

// MARK: - Constants
private enum Constants {
    static let spacing: CGFloat = 0
    static let borderWidth: CGFloat = 0.5
    static let reuseID = "GifCollectionViewCell"
}

