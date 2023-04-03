//
//  PreviewViewController.swift
//  mini-iTunes2
//
//  Created by Howe on 2023/4/2.
//

import UIKit
import WebKit
import SafariServices

class PreviewViewController: UIViewController {

    var urlString: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
      
    }
    



}
