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
    @State private var isConfigModalPresented = false
    @State private var showTrackingView = false
    
    @State private var isGoogleAnalyticsAllowed: Bool = false
    @State private var isFacebookAllowed: Bool = false
    @State private var isAdwordsAllowed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: -30) {
                    Text("Jentis SDK Demo")
                        .foregroundColor(Color.mainDark)
                        .font(.system(size: 35, weight: .bold))
                        .kerning(0.5)
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            showConsentModal.toggle()
                        }) {
                            Text("Consent Settings")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.brandBlue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .cornerRadius(12)
                                .overlay(
                                    colorScheme != .dark ?
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.brandBlue, lineWidth: 1) : nil
                                )
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            showTrackingView = true
                        }) {
                            Text("Tracking Examples")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.brandBlue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .background(
                            NavigationLink(destination: TrackingView(), isActive: $showTrackingView) {
                                EmptyView()
                            }
                                .hidden()
                        )
                    }
                    
                    Spacer()
                    
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                       let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("Version \(version) (\(build))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                    }
                }
                .padding()
                .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
                .sheet(isPresented: $showConsentModal) {
                    ConsentModalView(
                        isGoogleAnalyticsAllowed: $isGoogleAnalyticsAllowed,
                        isFacebookAllowed: $isFacebookAllowed,
                        isAdwordsAllowed: $isAdwordsAllowed,
                        onSave: setConsent
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isConfigModalPresented = true
                        }) {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $isConfigModalPresented) {
                    ConfigModalView { newConfig  in
                        JentisService.configure(with: newConfig)
                    }
                }
                
                if showSnackbar {
                    SnackbarView(message: snackbarMessage, isError: isError)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showSnackbar)
                }
            }
        }
    }
    
    private func setConsent(_ vendorConsents: [String: ConsentStatus]) async {
        do {
            try await TrackingService.shared.setConsents(vendorConsents)
            snackbarMessage = "Consent model sent successfully!"
            isError = false
        } catch {
            snackbarMessage = "Failed to send consent model."
            isError = true
        }
        showSnackbarWithDelay()
    }
    
    private func showSnackbarWithDelay() {
        showSnackbar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showSnackbar = false
        }
    }
}
