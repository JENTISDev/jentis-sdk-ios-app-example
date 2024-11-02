//
//  ContentView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 07/10/2024.
//

import SwiftUI
import JentisSDK

struct ContentView: View {
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    @State private var isError: Bool = false
    @State private var showConsentModal: Bool = false

    @State private var isGoogleAnalyticsAllowed: Bool = false
    @State private var isFacebookAllowed: Bool = false
    @State private var isAwinAllowed: Bool = false

    // Available actions from TrackingService
    private let actions: [(String, () async throws -> Void)] = [
        ("Send Data Submission Model", { try await TrackingService.shared.sendDataSubmissionModel() }),
        ("Add Item to Push Queue", {
            let randomData = generateRandomPushData()
            TrackingService.shared.push(customProperties: randomData)
        }),
        ("Submit Stored Push Data", { try await TrackingService.shared.submit() })
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Jentis SDK Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Select an action to perform.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                ForEach(actions, id: \.0) { action in
                    Button(action: {
                        performAction(action.1)
                    }) {
                        Text(action.0)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.jentisBlue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
                    showConsentModal.toggle()
                }) {
                    Text("Consent Modal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showConsentModal) {
                ConsentModalView(
                    isGoogleAnalyticsAllowed: $isGoogleAnalyticsAllowed,
                    isFacebookAllowed: $isFacebookAllowed,
                    isAwinAllowed: $isAwinAllowed,
                    onSave: setConsentModel
                )
            }

            if showSnackbar {
                SnackbarView(message: snackbarMessage, isError: isError)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showSnackbar)
            }
        }
    }

    private func setConsentModel(vendorConsents: [String: ConsentStatus]) async {
        do {
            try await TrackingService.shared.setConsents(
                vendorConsents: vendorConsents,
                vendorChanges: vendorConsents
            )
            snackbarMessage = "Consent model sent successfully!"
            isError = false
        } catch {
            snackbarMessage = "Failed to send consent model."
            isError = true
        }
        showSnackbarWithDelay()
    }

    private func performAction(_ action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
                snackbarMessage = "Action executed successfully!"
                isError = false
                showSnackbarWithDelay()
            } catch {
                snackbarMessage = "Failed to execute action."
                isError = true
                showSnackbarWithDelay()
            }
        }
    }

    private func showSnackbarWithDelay() {
        showSnackbar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showSnackbar = false
        }
    }
    
    private static func generateRandomPushData() -> [String: String] {
        let urls = [
            "https://www.example.com",
            "https://www.sampledomain.com",
            "https://www.testsite.org",
            "https://www.anotherexample.net"
        ]
        let titles = [
            "Welcome Page",
            "About Us",
            "Contact Page",
            "Product Details",
            "Blog Post"
        ]
        
        let events = [
            "pageview",
            "click",
            "purchase",
            "order",
        ]
        
        let randomURL = urls.randomElement() ?? "https://www.default.com"
        let randomTitle = titles.randomElement() ?? "Default Title"
        let randomEvent = events.randomElement() ?? "pageview"
        
        return [
            "track": randomEvent,
            "url": randomURL,
            "title": randomTitle
        ]
    }
}

