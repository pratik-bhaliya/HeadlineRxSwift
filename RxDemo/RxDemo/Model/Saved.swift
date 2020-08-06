//
//  Saved.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - SavedArticle
class SavedArticle: Object {
    @objc dynamic var author: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var articleDescription: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var urlToImage: String = ""

    convenience init(article: Article) {
        self.init()
        self.author = article.author ?? ""
        self.title = article.title ?? ""
        self.articleDescription = article.articleDescription ?? ""
        self.url = article.url ?? ""
        self.urlToImage = article.urlToImage ?? ""
    }
}
