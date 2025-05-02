//
//  BaseWebVC.swift
//  MeiLiao
//
//  Created by ganlingyun on 2024/1/22.
//

import UIKit
import WebKit

class BaseWebVC: BaseVC {
    var h5Title: String? {
        didSet {
            title = h5Title
        }
    }
    let urlString: String
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()
    
    init(_ urlString: String) {
        self.urlString = urlString
        print("urlstring is \(urlString)")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isClearNavigationBar = false
        self.isNavigationBarHidden = true
        let backBt = UIButton()
        backBt.setBackgroundImage(UIImage(named: "kaitongBG"), for: .normal)
        view.addSubview(backBt)
        backBt.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalTo(16)
            make.top.equalTo(52)
        }
        backBt.addTarget(self, action: #selector(backbtClick), for: .touchUpInside)
        
        view.addSubview(webView)
        if let url = URL.init(string: urlString) {
            webView.load(.init(url: url))
        }
    }
    
    @objc func backbtClick(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88)
    }
    
    deinit {
        webView.stopLoading()
        webView.navigationDelegate = nil
    }
}

extension BaseWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //显示loading
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //显示loading
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //隐藏loading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 获取title
        webView.evaluateJavaScript("document.title") {[weak self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.h5Title = response as? String
        }
    }
}
