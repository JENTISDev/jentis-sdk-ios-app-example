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

    // Available actions from TrackingService
    private let actions: [(String, () async throws -> Void)] = [
        ("Send Consent Model", { try await TrackingService.shared.sendConsentModel() }),
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

                // Dynamically creating buttons for each action
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

                Spacer()
            }
            .padding()
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))

            if showSnackbar {
                SnackbarView(message: snackbarMessage, isError: isError)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showSnackbar)
            }
        }
    }

    private func performAction(_ action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
                DispatchQueue.main.async {
                    snackbarMessage = "Action executed successfully!"
                    isError = false
                    showSnackbarWithDelay()
                }
            } catch {
                DispatchQueue.main.async {
                    snackbarMessage = "Failed to execute action."
                    isError = true
                    showSnackbarWithDelay()
                }
            }
        }
    }

    private func showSnackbarWithDelay() {
        showSnackbar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showSnackbar = false
        }
    }
    
    // Helper function to generate random push data
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
