//
//  HeadlineViewController.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HeadlineViewController: UIViewController {
    
    @IBOutlet weak var headlineTableView: UITableView!
    var selectedArticleIndex = 0
    let viewModel = HeadlinesViewModel()
    private let disposeBag = DisposeBag()
    private lazy var realMViewModel: RealMViewModel = {
        let result = RealMViewModel()
        result.delegate = self
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headlineTableView.register(UINib(nibName: "HeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "HeadlineTableViewCell")
        headlineTableView.tableFooterView = UIView()
        headlineTableView.delegate = self
        self.bindViews()
    }
    
    private func bindViews() {
        
        self.viewModel.output.article
            .drive(self.headlineTableView.rx.items(cellIdentifier: "HeadlineTableViewCell", cellType: HeadlineTableViewCell.self)) { (row, articles, cell) in
                cell.configureCell(articles)
        }
        .disposed(by: disposeBag)
        
        // selecting articles
        self.headlineTableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] article in
            guard let self = self else { return }
            let detailViewController = HeadlineDetailViewController()
            detailViewController.delegate = self
            if let selectedUrl = article.url {
                detailViewController.urlString = selectedUrl
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            if let selectedRowIndexPath = self.headlineTableView.indexPathForSelectedRow {
                self.selectedArticleIndex = selectedRowIndexPath.row
            }//4
            
            }).disposed(by: disposeBag)
        
//        Observable.zip(headlineTableView.rx.itemSelected, headlineTableView.rx.modelSelected(Article.self)).bind {
//            [weak self] indexPath, article in
//            guard let self = self else { return }
//            let detailViewController = HeadlineDetailViewController()
//            self.selectedArticleIndex = indexPath.row
//            if let selectedUrl = article.url {
//                detailViewController.urlString = selectedUrl
//                self.navigationController?.pushViewController(detailViewController, animated: true)
//            }
//        }.disposed(by: disposeBag)
        
        // Error message
        self.viewModel.output.errorMessage
            .drive(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.showError(errorMessage)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.input.reload.accept(())
    }
    
    // MARK: - UI
    
    private func showError(_ errorMessage: String) {
        
        // display error ?
        let controller = UIAlertController(title: "An error occurred", message: "Oops, something went wrong!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension HeadlineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    
}

extension HeadlineViewController: SaveArticleDelegate {
    func saveArticle() {
        
        self.viewModel.output.article.asObservable().subscribe(onNext: { [weak self] article in
            guard let self = self else { return }
            let selectedArticle = article[self.selectedArticleIndex]
            let savedArticle = SavedArticle(article: selectedArticle)
            self.realMViewModel.insertObject(savedArticle)
        }).disposed(by: disposeBag)
    }
}

extension HeadlineViewController: RealMViewModelDelegate {
    func objectSaved() {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Headline", message: "Article successfully saved.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func objectSavingFailed(error: NSError) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Headline", message: "Oops, Article couldn't saved!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
}
