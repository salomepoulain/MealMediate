//
//  Website.swift
//  project
//
//  Created by Salome Poulain on 12/12/2023.
//

import SwiftUI
import WebKit

// MARK: - WebView

// A SwiftUI view that displays a web page using `WKWebView`.
struct WebView: UIViewRepresentable {
    let urlString: String

    // MARK: - UIViewRepresentable methods

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Load the web page when the URL is available
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    // A coordinator class that acts as a delegate for `WKWebView`.
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

    }
}

// MARK: - Website

// The main SwiftUI view that displays a website using the `WebView`.
struct Website: View {
    var body: some View {
        WebView(urlString: "https://www.voedingscentrum.nl/nl/gezond-eten-met-de-schijf-van-vijf/hoe-eet-je-gezond-en-duurzaam.aspx")
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
    }
}
