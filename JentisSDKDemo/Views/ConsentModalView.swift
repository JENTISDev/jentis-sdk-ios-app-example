//
//  ConsentModalView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 02/11/2024.
//
import SwiftUI
import JentisSDK

struct ConsentModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isGoogleAnalyticsAllowed: Bool
    @Binding var isFacebookAllowed: Bool
    @Binding var isAdwordsAllowed: Bool
    @State private var isGoogleAnalyticsNCM: Bool = false
    @State private var isFacebookNCM: Bool = false
    @State private var isAdwordsNCM: Bool = false
    let onSave: ([String: ConsentStatus]) async -> Void

    private let userDefaults = UserDefaults.standard

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Configure Vendors Consent")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 2)
                
                Text("Manage which vendors are allowed to track your data.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical)
            
            Divider()
            
            VStack(spacing: 16) {
                consentToggle(title: "GA4 server-side", isOn: $isGoogleAnalyticsAllowed, ncmBinding: $isGoogleAnalyticsNCM, color: .brandGreen)
                consentToggle(title: "Facebook", isOn: $isFacebookAllowed, ncmBinding: $isFacebookNCM, color: .brandGreen)
                consentToggle(title: "Google Ads", isOn: $isAdwordsAllowed, ncmBinding: $isAdwordsNCM, color: .brandGreen)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: saveConsents) {
                Text("Save Changes")
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
        .onAppear(perform: loadConsents)
    }
    
    private func saveConsents() {
        // Save current selections to UserDefaults
        userDefaults.set(isGoogleAnalyticsAllowed, forKey: "isGoogleAnalyticsAllowed")
        userDefaults.set(isFacebookAllowed, forKey: "isFacebookAllowed")
        userDefaults.set(isAdwordsAllowed, forKey: "isAdwordsAllowed")
        userDefaults.set(isGoogleAnalyticsNCM, forKey: "isGoogleAnalyticsNCM")
        userDefaults.set(isFacebookNCM, forKey: "isFacebookNCM")
        userDefaults.set(isAdwordsNCM, forKey: "isAdwordsNCM")

        // Map to ConsentStatus and pass to onSave
        let vendorConsents: [String: ConsentStatus] = [
            "google_analytics_4_server-side": isGoogleAnalyticsNCM ? .ncm : (isGoogleAnalyticsAllowed ? .allow : .deny),
            "facebook": isFacebookNCM ? .ncm : (isFacebookAllowed ? .allow : .deny),
            "adwords": isAdwordsNCM ? .ncm : (isAdwordsAllowed ? .allow : .deny)
        ]
        presentationMode.wrappedValue.dismiss()
        Task { await onSave(vendorConsents) }
    }
    
    private func loadConsents() {
        // Load saved values from UserDefaults
        isGoogleAnalyticsAllowed = userDefaults.bool(forKey: "isGoogleAnalyticsAllowed")
        isFacebookAllowed = userDefaults.bool(forKey: "isFacebookAllowed")
        isAdwordsAllowed = userDefaults.bool(forKey: "isAdwordsAllowed")
        isGoogleAnalyticsNCM = userDefaults.bool(forKey: "isGoogleAnalyticsNCM")
        isFacebookNCM = userDefaults.bool(forKey: "isFacebookNCM")
        isAdwordsNCM = userDefaults.bool(forKey: "isAdwordsNCM")
    }
    
    @ViewBuilder
    private func consentToggle(title: String, isOn: Binding<Bool>, ncmBinding: Binding<Bool>, color: Color) -> some View {
        HStack {
            Toggle(isOn: isOn) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .toggleStyle(SwitchToggleStyle(tint: color))
            .disabled(ncmBinding.wrappedValue) // Disable if NCM is selected
            
            Spacer()
            
            // NCM Checkbox
            HStack {
                Text("NCM")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Toggle("", isOn: ncmBinding)
                    .labelsHidden()
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: ncmBinding.wrappedValue) { isNCMSelected in
                        if isNCMSelected {
                            isOn.wrappedValue = false // Reset main toggle if NCM is selected
                        }
                    }
            }
            .padding(.horizontal)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

// Custom checkbox toggle style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .blue : .secondary)
                .imageScale(.large)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
