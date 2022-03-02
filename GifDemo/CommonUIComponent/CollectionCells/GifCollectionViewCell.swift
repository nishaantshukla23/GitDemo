//
//  GifCollectionViewCell.swift
//  GifDemo
//
//  Created by omsairam on 25/02/22.
//

import UIKit
import Alamofire
import AlamofireImage

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var btnFavorite: UIButton!
    
    // Note: must be strong
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
    
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        btnFavorite.setImage(UIImage(named: "favoriteUnfilled"), for: .normal)

    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        btnFavorite.setImage(UIImage(named: "favoriteFilled"), for: .normal)
    }
    
    func loadGif(gif: GifModel){
//        imageView.image = UIImage.gif(url: gif.url)
        if let url = URL(string: gif.gifSources.original.url ) {
            imageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder_image"), imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true)
            
        }
    }
}
