//
//  SourcesViewController.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SourcesViewController: UIViewController {
    
    @IBOutlet weak var sourcesTableview: UITableView!
    var selectedIndexPaths = Set<IndexPath>()
    let viewModel = SourceViewModel()
    private let disposeBag = DisposeBag()
    var selectedSources: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourcesTableview.register(UINib(nibName: "SourceTableViewCell", bundle: nil), forCellReuseIdentifier: "SourceTableViewCell")

        sourcesTableview.estimatedRowHeight = 100.0
        sourcesTableview.rowHeight = UITableView.automaticDimension
        
        // Empty tableview will be clear to zero
        self.sourcesTableview.tableFooterView = UIView()
        self.bindViews()
    }
    
    private func bindViews() {
        
        // cellforrow at indexpath
        self.viewModel.output.article
            .drive(self.sourcesTableview.rx.items(cellIdentifier: "SourceTableViewCell", cellType: SourceTableViewCell.self)) { (row, source, cell) in
                cell.configureCell(source)
        }
        .disposed(by: disposeBag)
        
        // didselect
        Observable.zip(sourcesTableview.rx.itemSelected, sourcesTableview.rx.modelSelected(Source.self)).bind {
            [weak self] indexPath, source in
            guard let self = self else { return }
            
            
            if self.selectedIndexPaths.contains(indexPath) { //deselect
                self.selectedIndexPaths.remove(indexPath)
                self.sourcesTableview.cellForRow(at: indexPath)?.accessoryType = .none
                
                // Remove unselected sources
                for (index,value) in self.selectedSources.enumerated() {
                    if value == source.name {
                        self.selectedSources.remove(at: index)
                    }
                }
                
            }
            else{
                self.selectedIndexPaths.insert(indexPath) //select
                self.sourcesTableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
                // Add source to global array.
                self.selectedSources.append(source.name)
            }
            SelectedSource.shared.collectionArray.accept(self.selectedSources)
        }.disposed(by: disposeBag)
        
        self.sourcesTableview.rx.willDisplayCell
            .subscribe(onNext: {[weak self] cell, indexPath in
                guard let self = self else { return }
                cell.accessoryType = self.selectedIndexPaths.contains(indexPath) ? .checkmark : .none
            }).disposed(by: disposeBag)
        //Error message
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
        let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
}
