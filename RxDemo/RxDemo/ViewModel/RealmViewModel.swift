//
//  RealmViewModel.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - DB Protocol Methods
protocol RealMViewModelDelegate {
    func objectSaved()
    func objectSavingFailed(error: NSError)
    func objectFetched(_ headlines: [SavedArticle])
    func objectRemoved()
}

// Make RealMViewModelDelegate methods optionals
extension RealMViewModelDelegate {
    func objectSaved() {}
    func objectSavingFailed(error: NSError) {}
    func objectFetched(_ headlines: [SavedArticle]) {}
    func objectRemoved() {}
}

final class RealMViewModel: NSObject {
    // MARK: -  Instant Properties
    let realm = try! Realm()
    var delegate: RealMViewModelDelegate?
    
    // MARK: -DB Helper Methods
    func insertObject(_ article: SavedArticle) {
        try! realm.write {
            realm.add(article)
            delegate?.objectSaved() // Notify for article successful insertion
        }
    }
    
    func fetchObjects() {
        let fetchedArticle = realm.objects(SavedArticle.self)
        if fetchedArticle.count > 0 {
            var fetchedArticles = [SavedArticle]()
            fetchedArticle.forEach {fetchedArticles.append($0)}
            delegate?.objectFetched(fetchedArticles)
        } else {
            delegate?.objectFetched([])
        }
    }
    
    func removeObjectAtIndex(_ headline: SavedArticle) {
        // Persist your data easily
        try! realm.write {
            realm.delete(headline)
            delegate?.objectRemoved() // Notify successfully deleted
        }
    }
    
}
