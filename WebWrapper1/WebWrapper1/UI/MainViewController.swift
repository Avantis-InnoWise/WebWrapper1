//
//  MainViewController.swift
//  WebWrapper1
//
//  Created by user on 17.02.2022.
//

import Cocoa
import WebKit

final class MainViewController: NSViewController {
    
    lazy private var buttonBack = setupButtonBack()
    lazy private var buttonHome = setupButtonHome()
    lazy private var buttonForward = setupButtonForward()
    
    lazy private var boxView: NSBox = setupBoxView()
    lazy private var webView: WKWebView = setupWebView()
    
    override func loadView() {
        self.view = NSView(frame: NSRect(origin: CGPoint(), size: CGSize(width: 836, height: 644)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let url = baseUrl {
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    private func setupView() {
        self.view.layer?.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }
    
    @objc private func backButtonAction() {
        if buttonBack.isEnabled { webView.goBack() }
    }

    @objc private func forwardButtonAction() {
        if buttonForward.isEnabled { webView.goForward() }
    }

    @objc private func homeButtonAction() {
        if let url = baseUrl { self.webView.load(URLRequest(url: url)) }
    }
}

//MARK: Setup components for MainViewController
private extension MainViewController {
    
    func setupButtonBack() -> NSButton {
        let button = NSButton()
        button.configurate(title: Localized.buttonBackTitle, action: #selector(backButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }
    
    func setupButtonHome() -> NSButton {
        let button = NSButton()
        button.configurate(title: Localized.buttonHomeTitle, action: #selector(homeButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupButtonForward() -> NSButton {
        let button = NSButton()
        button.configurate(title: Localized.buttonForwardTitle, action: #selector(forwardButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }
    
    func setupBoxView() -> NSBox {
        let box = NSBox()
        box.boxType = .custom
        box.cornerRadius = 0
        box.borderWidth = 1
        box.borderColor = NSColor.secondaryLabelColor
        box.fillColor = .windowBackgroundColor
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }
    
    func setupWebView() -> WKWebView {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }
    
    func addSubviews() {
        self.view.addSubview(boxView)
        self.view.addSubview(webView)
        self.boxView.addSubview(buttonBack)
        self.boxView.addSubview(buttonHome)
        self.boxView.addSubview(buttonForward)
    }
    
    func addConstraints() {
        boxView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        boxView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        buttonBack.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.centerYAnchor.constraint(equalTo: self.boxView.centerYAnchor).isActive = true
        buttonBack.leftAnchor.constraint(equalTo: self.boxView.leftAnchor, constant: 30).isActive = true
        
        buttonHome.widthAnchor.constraint(equalToConstant: 120).isActive = true
        buttonHome.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonHome.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonHome.centerYAnchor.constraint(equalTo: self.boxView.centerYAnchor).isActive = true
        
        buttonForward.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buttonForward.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonForward.centerYAnchor.constraint(equalTo: self.boxView.centerYAnchor).isActive = true
        buttonForward.rightAnchor.constraint(equalTo: self.boxView.rightAnchor, constant: -30).isActive = true
        
        webView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.boxView.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        buttonBack.isEnabled = webView.backForwardList.backList.isEmpty ? false : true
        buttonForward.isEnabled = webView.backForwardList.forwardList.isEmpty ? false : true
    }
}

//MARK: WKUIDelegate
extension MainViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            if let newURL = navigationAction.request.url {
                self.webView.load(URLRequest(url: newURL))
            }
        }
        return nil
    }
}
