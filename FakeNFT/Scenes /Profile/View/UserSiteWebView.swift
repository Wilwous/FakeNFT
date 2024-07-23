//
//  UserSiteWebView.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 29.06.2024.
//

import UIKit
import WebKit

final class LicenceWebViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var webView: WKWebView!
    private var targetURL: String?
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupActivityIndicator()
        loadRequest()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods

    private func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view = webView
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    private func loadRequest() {
        guard let urlStr = targetURL, let url = URL(string: urlStr) else {
            displayErrorPage()
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func displayErrorPage() {
        let html = """
        <html>
        <head><title>Ошибка</title></head>
        <body>
        <h1>Страница не найдена</h1>
        <h1>Проверьте правильность введенного адреса и попробуйте снова.</h1>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

    private func setupNavigationBar() {
        let backIcon = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backIcon,
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackDay
    }

    private func leftToRightTransition() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
    }

    @objc func backTapped() {
        leftToRightTransition()
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - WKNavigationDelegate

extension LicenceWebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        activityIndicator.startAnimating()
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        activityIndicator.stopAnimating()
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        activityIndicator.stopAnimating()
        displayErrorPage()
    }
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        activityIndicator.stopAnimating()
        displayErrorPage()
    }
}
