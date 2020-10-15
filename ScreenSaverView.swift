//
//  ScreenSaverView.swift
//  ScreenSavar
//
//  Created by T.Yanagi on 2020/10/16.
//

import ScreenSaver
import WebKit

class MyScreenSaverView: ScreenSaverView, WKNavigationDelegate {
    private var webView: WKWebView!

    convenience init() {
        self.init(frame: .zero, isPreview: false)
    }

    override init!(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setupWebView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWebView()
    }

    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        // webkitがローカルファイルを参照できるようにする設定
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        // webViewをスクリーンの大きさに合わせる
        webView = WKWebView(frame: NSRect(x: 0, y: 0, width: frame.width, height: frame.height), configuration: webConfiguration)
        webView.navigationDelegate = self
        // webViewの背景を透明にする
        webView.setValue(false, forKey: "drawsBackground")
        // スワイプでの戻る/進むを無効にする
        webView.allowsBackForwardNavigationGestures = false
        // ピンチで拡大/縮小できる機能を無効にする
        webView.allowsMagnification = false

        // ローカルのHTMLを読み込む
        if let htmlPath = Bundle(for: type(of: self)).path(forResource: "html", ofType: nil) {
            let htmlUrl = URL(fileURLWithPath: htmlPath, isDirectory: true)
            let indexUrl = URL(fileURLWithPath: htmlPath + "/index.html", isDirectory: false)
            webView.loadFileURL(indexUrl, allowingReadAccessTo: htmlUrl)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // ページが遷移したタイミングでwebViewをスクリーンセーバに表示する
        self.addSubview(webView)
    }

    // マウスが動いたときにスクリーンセーバが解除されるようにする(その1)
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        self
    }

    // マウスが動いたときにスクリーンセーバが解除されるようにする(その2)
    override var acceptsFirstResponder: Bool {
        true
    }
}
