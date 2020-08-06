//
//  SourceViewModel.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct SourceViewModel {
    weak var service: NetworkServiceProtocol?
    
    let input: Input
    let output: Output
    
    struct Input {
        let reload: PublishRelay<Void>
    }
    
    struct Output {
        let article: Driver<[Source]>
        let errorMessage: Driver<String>
    }
    
    init(service: NetworkServiceProtocol = NetworkManager.shared) {
        self.service = service
        
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        let articles = reloadRelay
        .asObservable()
            .flatMapLatest({ service.get(with: .sources, responseType: Sources.self) })
            .map({ $0.sources })
        .asDriver { (error) -> Driver<[Source]> in
            errorRelay.accept((error as? NetworkError)?.localizedDescription ?? error.localizedDescription)
            return Driver.just([])
        }
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(article: articles, errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error occurred."))
    }
}
