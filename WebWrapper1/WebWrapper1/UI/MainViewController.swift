//
//  MainViewController.swift
//  WebWrapper1
//
//  Created by user on 17.02.2022.
//

import Cocoa
import WebKit

final class MainViewController: NSViewController {
    
    lazy private var btnBck = setupButtonBack()
    lazy private var btnHem = setupButtonHome()
    lazy private var btnFwd = setupButtonForward()
    
    lazy private var bxVew: NSBox = setupBoxView()
    lazy private var wbVew: WKWebView = setupWebView()
    
    override func loadView() {
        self.view = NSView(frame: NSRect(origin: CGPoint(), size: CGSize(width: 836, height: 644)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wbVew.navigationDelegate = self
        self.wbVew.uiDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let url = baseUrl {
                self.wbVew.load(URLRequest(url: url))
            }
        }
    }
    
    private func setupView() {
        self.view.layer?.backgroundColor = .white
        self.addSubviews()
        self.addConstraints()
    }
    
    @objc private func backButtonAction() {
        if btnBck.isEnabled { wbVew.goBack() }
    }

    @objc private func forwardButtonAction() {
        if btnFwd.isEnabled { wbVew.goForward() }
    }

    @objc private func homeButtonAction() {
        if let url = baseUrl { self.wbVew.load(URLRequest(url: url)) }
    }
}

//MARK: Setup components for MainViewController
private extension MainViewController {
    
    func setupButtonBack() -> NSButton {
        let button = NSButton()
        button.configurate(title: Localized.buttonBackTitle, action: #selector(backButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer?.backgroundColor = NSColor.lightGray.cgColor
        return button
    }
    
    func setupButtonHome() -> NSButton {
        let button = NSButton()
        button.configurate(title: Localized.buttonHomeTitle, action: #selector(homeButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer?.backgroundColor = NSColor.lightGray.cgColor
        return button
    }
    
    func setupButtonForward() -> NSButton {
        let button = NSButton()
        button.configurate(title: Localized.buttonForwardTitle, action: #selector(forwardButtonAction))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer?.backgroundColor = NSColor.lightGray.cgColor
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
        self.view.addSubview(bxVew)
        self.view.addSubview(wbVew)
        self.bxVew.addSubview(btnBck)
        self.bxVew.addSubview(btnHem)
        self.bxVew.addSubview(btnFwd)
    }
    
    func addConstraints() {
        bxVew.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bxVew.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bxVew.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        btnBck.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btnBck.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnBck.centerYAnchor.constraint(equalTo: self.bxVew.centerYAnchor).isActive = true
        btnBck.leftAnchor.constraint(equalTo: self.bxVew.leftAnchor, constant: 30).isActive = true
        
        btnHem.widthAnchor.constraint(equalToConstant: 120).isActive = true
        btnHem.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnHem.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        btnHem.centerYAnchor.constraint(equalTo: self.bxVew.centerYAnchor).isActive = true
        
        btnFwd.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btnFwd.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnFwd.centerYAnchor.constraint(equalTo: self.bxVew.centerYAnchor).isActive = true
        btnFwd.rightAnchor.constraint(equalTo: self.bxVew.rightAnchor, constant: -30).isActive = true
        
        wbVew.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        wbVew.topAnchor.constraint(equalTo: self.bxVew.bottomAnchor).isActive = true
        wbVew.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        btnBck.isEnabled = webView.backForwardList.backList.isEmpty ? false : true
        btnFwd.isEnabled = webView.backForwardList.forwardList.isEmpty ? false : true
    }
}

//MARK: WKUIDelegate
extension MainViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
            if let newURL = navigationAction.request.url {
                self.wbVew.load(URLRequest(url: newURL))
            }
        }
        return nil
    }
}
