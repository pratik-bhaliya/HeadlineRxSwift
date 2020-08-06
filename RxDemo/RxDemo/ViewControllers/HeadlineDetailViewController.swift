//
//  HeadlineDetailViewController.swift
//  RxDemo
//
//  Created by Pratik Bhaliya on 30/7/20.
//  Copyright © 2020 Pratik Bhaliya. All rights reserved.
//

import UIKit
import WebKit

protocol SaveArticleDelegate {
    func saveArticle()
}

class HeadlineDetailViewController: UIViewController {
    
    // MARK: - Instant Properties
    var delegate: SaveArticleDelegate?
    var urlString: String?
    
    lazy var detailWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .large
        return loadingIndicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebViewConstraints()
        setupNavItem()
        loadWebView()
    }
    
    // MARK: - Class
    fileprivate func loadWebView() {
        guard let articleURL = urlString else { return }
        let url = URL(string: articleURL)
        let request = URLRequest(url: url!)
        detailWebView.load(request)
    }
    
    // Customise navigation bar
    fileprivate func setupNavItem() {
        let forwardBarItem = UIBarButtonItem(title: "Save", style: .plain, target: self,
                                             action: #selector(saveButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = forwardBarItem
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // Setting web view and constraint
    fileprivate func setWebViewConstraints() {
        self.view.backgroundColor = .white
        self.view.addSubview(detailWebView)
        //self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            detailWebView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            detailWebView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            detailWebView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            detailWebView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    // Save button pressed
    @objc func saveButtonPressed(sender: UIBarButtonItem) {
        delegate?.saveArticle()
    }
}

// MARK: - WKNavigationDelegate
extension HeadlineDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //self.stopeActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //self.startActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //self.stopeActivityIndicator()
    }
}
