//
//  Website.swift
//  project
//
//  Created by Salome Poulain on 12/12/2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

    }
}

struct Website: View {
    var body: some View {
        WebView(urlString: "https://www.voedingscentrum.nl/nl/gezond-eten-met-de-schijf-van-vijf/hoe-eet-je-gezond-en-duurzaam.aspx")
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
    }
}


