//
//  ViewController.swift
//  GifDemo
//
//  Created by omsairam on 25/02/22.
//

import UIKit
import Alamofire

class GifSearcherVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
 //   var gifs = [GifModel]()
    fileprivate var gifFeed = GifFeedModel(type: .trending)
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var loaded: Bool = false
    fileprivate var reachability: NetworkReachabilityManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.layer.borderWidth = 1.0
        // Search bar
            searchBar.searchTextField.delegate = self
            searchBar.searchTextField.placeholder = "Whats your favorite gif?"
            searchBar.returnKeyType = .search
        
        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(GifSearcherVC.refreshFeed), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        // reachability
        reachability = NetworkReachabilityManager()
        reachability.startListening()
        reachability.listener = { status -> Void in
            switch status {
            case .notReachable:
                self.updateNoInternetOverlay()
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                (self.loaded == false) ? self.loadFeed() : self.loadMoreFeed()
                UIView.animate(withDuration: 0.4, animations: {
                    self.noInternetOverlay.backgroundColor = Constants.Green
                    }, completion: { done -> Void in
                        UIView.animate(withDuration: 0.3, animations: {
                            var rect = self.noInternetOverlay.frame
                            rect.size.height = 0
                            self.noInternetOverlay.frame = rect
                        })
                })
            default: break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.endRefreshing()
    }
    
    // MARK: Subview & Orientation
    
    func updateNoInternetOverlay() {
        self.noInternetOverlay.backgroundColor = Constants.Red
        if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown {
            self.noInternetOverlay.frame = CGRect(x: 0, y: 64, width: ((Constants.screenHeight < Constants.screenWidth) ? Constants.screenHeight : Constants.screenWidth), height: 40)
        } else {
            self.noInternetOverlay.frame = CGRect(x: 0, y: 44 + ((UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 0), width: ((Constants.screenHeight > Constants.screenWidth) ? Constants.screenHeight : Constants.screenWidth), height: 40)
        }
    }
    
    // MARK: Feeds
    
    @objc func refreshFeed() {
        gifFeed.clearFeed()
        collectionView.reloadData()
        refreshControl.endRefreshing()
        loadMoreFeed()
    }
    
    func loadFeed() {
        gifFeed.requestFeed(20, offset: 0, rating: nil, terms: nil, comletionHandler: { (succeed, _, error) -> Void in
            if succeed {
                self.loaded = true
                self.collectionView.reloadData()
                self.loadMoreFeed()
            } else if let error = error {
                let alert = self.alertControllerWithMessage(error)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func loadMoreFeed() {
        gifFeed.requestFeed(20, offset: gifFeed.currentOffset, rating: nil, terms: nil, comletionHandler: { (succeed, total, error) -> Void in
            if succeed, let total = total {
                self.collectionView.performBatchUpdates({
                    
                    var indexPaths = [IndexPath]()
                    for i in (self.gifFeed.currentOffset - total)..<self.gifFeed.currentOffset {
                        let indexPath = IndexPath.init(item: i, section: 0)
                        indexPaths.append(indexPath)
                    }
                    self.collectionView.insertItems(at: indexPaths)
                    
                    }, completion: { done -> Void in
                        
                })
            } else if let error = error {
                let alert = self.alertControllerWithMessage(error)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.bounds.intersects(CGRect(x: 0, y: collectionView.contentSize.height - Constants.screenHeight / 2, width: collectionView.frame.width, height: Constants.screenHeight / 2)) && collectionView.contentSize.height > 0 && reachability.isReachable {
            loadMoreFeed()
        }
    }
}

// MARK: - Search bar functions
extension GifSearcherVC: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != nil {
                searchGifs(for: textField.text!)
        }
        return true
    }
    
    /**
        Fetches gifs based on the search term and populates tableview
        - Parameter searchTerm: The string to search gifs of
        */
        func searchGifs(for searchText: String) {
            GifNetworkManager.shared.fetchGifs(searchTerm: searchText) { gifArray in
                if gifArray != nil {
                    self.gifFeed.gifsArray = gifArray!.gifs
                    self.collectionView.reloadData()
                }
            }
        }
    
}

// MARK: - Collection view delegate and data source methods
extension GifSearcherVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifFeed.gifsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIConstants.reuseID, for: indexPath) as! GifCollectionViewCell
        
        cell.layer.borderWidth = UIConstants.borderWidth
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.maxWidth = collectionView.bounds.width - UIConstants.spacing
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.red.cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.imageView.layer.borderWidth = 3.0
        cell.imageView.layer.borderColor = UIColor.green.cgColor
        cell.loadGif(gif: self.gifFeed.gifsArray[indexPath.item])
        return cell
    }
}

// MARK: - Constants
private enum UIConstants {
    static let spacing: CGFloat = 0
    static let borderWidth: CGFloat = 0.5
    static let reuseID = "GifCollectionViewCell"
}



extension UIViewController {
    
    // MARK: No Internet Overlay
    var noInternetOverlay: UIView {
        
        if let overlay = view.viewWithTag(Constants.noInternetOverlayTag) {
            return overlay
        }
        
        let overlay = UIView()
        overlay.tag = Constants.noInternetOverlayTag
        overlay.backgroundColor = Constants.Red
        self.view.addSubview(overlay)
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = "No Internet Connection"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(label)
        
        let centerX = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: overlay, attribute: .centerX, multiplier: 1.0, constant: 0)
        overlay.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: overlay, attribute: .centerY, multiplier: 1.0, constant: 0)
        overlay.addConstraint(centerY)
        let leftMargin = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: overlay, attribute: .leading, multiplier: 1.0, constant: 0)
        overlay.addConstraint(leftMargin)
        let TopMargin = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: overlay, attribute: .top, multiplier: 1.0, constant: 0)
        overlay.addConstraint(TopMargin)
        
        return overlay
        
    }
    
    // MARK: AlertController
    func alertControllerWithMessage(_ message: String) -> UIAlertController {
        
        let alertController = UIAlertController.init(title: "GifSearcher", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(confirm)
        return alertController
        
    }
    
}
