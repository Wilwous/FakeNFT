//  AuthorWebViewController.swift
//  FakeNFT
//
//  Created by Антон Павлов on 12.07.2024.
//

import UIKit
import WebKit

final class AuthorWebViewController: UIViewController, LoadingView {
    
    // MARK: - Private Properties
    
    private let websiteLinkString: String
    
    // MARK: - UI Components
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(
            style: .large
        )
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private lazy var authorWebView: WKWebView = {
        let web = WKWebView(
            frame: .zero
        )
        web.navigationDelegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        
        return web
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addElements()
        layoutConstraint()
        loadWebView()
    }
    
    // MARK: - Initializers
    
    init(websiteLinkString: String) {
        self.websiteLinkString = websiteLinkString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func loadWebView() {
        if let url = URL(string: websiteLinkString) {
            showLoading()
            authorWebView.load(URLRequest(url: url))
        } else {
            showErrorAlert()
        }
    }
    
    // MARK: - Alert
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Произошла ошибка сети",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
        )
        present(
            alert,
            animated: true,
            completion: nil
        )
        print("Network error occurred")
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        view.addSubview(authorWebView)
        view.addSubview(activityIndicator)
    }
    
    private func layoutConstraint() {
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor
                ),
                
                activityIndicator.centerYAnchor.constraint(
                    equalTo: view.centerYAnchor
                ),
                
                authorWebView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                
                authorWebView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
                ),
                
                authorWebView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                
                authorWebView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor
                )
            ]
        )
    }
    
    private func setUpNavigationBarBackButton() {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: " ",
            style: .plain,
            target: nil,
            action: nil
        )
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black
    }
}

//MARK: - WKNavigationDelegate

extension AuthorWebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        self.showLoading()
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        self.hideLoading()
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        self.hideLoading()
        self.showErrorAlert()
    }
}
