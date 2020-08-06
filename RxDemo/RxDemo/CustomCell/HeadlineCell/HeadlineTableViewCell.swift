//
//  HeadlineTableViewCell.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headlineTitle: UILabel!
    @IBOutlet weak var headlineImageView: UIImageView!
    @IBOutlet weak var headlineSubtitle: UILabel!
    @IBOutlet weak var headlineAuthor: UILabel!
    
    // MARK: - Instant property
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialisation code
        setupCell()
    }

    // MARK: - Class
    fileprivate func setupCell() {
         self.backView.layer.cornerRadius = 10.0
         self.backView.layer.masksToBounds = true
         if #available(iOS 13.0, *) {
             self.contentView.layer.borderWidth = 0.2
             self.contentView.layer.borderColor = UIColor.label.cgColor
         }
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         gradientLayer.frame = self.bounds
         gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor ]
         headlineImageView.layer.insertSublayer(gradientLayer, at: 0)
     }
    
    func configureCell(_ article: Article) {
        self.headlineTitle.text = article.title ?? ""
        self.headlineSubtitle.text = article.articleDescription ?? ""
        self.headlineAuthor.text = article.author
        
        if let url = article.urlToImage {
            self.headlineImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: ""))
        }
    }
    
    
    func configureSavedCell(_ article: SavedArticle) {
        headlineTitle.text = article.title
        headlineSubtitle.text = article.articleDescription
        headlineAuthor.text = article.author
        headlineImageView.loadImageUsingCacheWithURLString(article.urlToImage, placeHolder: UIImage(named: "placeholder"))
    }
}
