//
//  ViewController.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import SafariServices

class SavedViewController: UIViewController {
    
    @IBOutlet weak var savedTableView: UITableView!
    private lazy var realMViewModel: RealMViewModel = {
        let result = RealMViewModel()
        return result
    }()
    
    private let disposeBag = DisposeBag()
    var fetchedArticle: Results<SavedArticle>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTableView.register(UINib(nibName: "HeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "HeadlineTableViewCell")
        savedTableView.delegate = self
        savedTableView.tableFooterView = UIView()
        self.bindViews()
    }
    
    private func bindViews() {
        self.savedTableView.dataSource = self
        let realm = try! Realm()
        fetchedArticle = realm.objects(SavedArticle.self)
        
        Observable.changeset(from: fetchedArticle)
            .subscribe(onNext: { [unowned self] _, changes in
                if let changes = changes {
                    self.savedTableView.applyChangeset(changes)
                } else {
                    self.savedTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}


extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArticle.count
    }
    
    // Cell configuration and setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadlineTableViewCell") as! HeadlineTableViewCell
        cell.configureSavedCell(fetchedArticle[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Observable.from([fetchedArticle[indexPath.row]])
                .subscribe(Realm.rx.delete())
                .disposed(by: disposeBag)
        }
    }
}

extension SavedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = self.fetchedArticle[indexPath.row].url
        let headlineDetail = SFSafariViewController(url: URL(string: selectedNews)!)
        present(headlineDetail, animated: true)
    }
}



    

