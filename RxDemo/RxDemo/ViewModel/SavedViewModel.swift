//
//  SavedViewModel.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 31/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm


struct SavedViewModel {
    let realm = try! Realm()
    
    func fetchedUpdatedResult() -> Disposable {
        let fetchedArticle = realm.objects(SavedArticle.self)
        return Observable.collection(from: fetchedArticle)
            .map {
                laps in "\(laps.count) laps"
        }
        .subscribe(onNext: { text  in
            print(text)
        })
    }
}
