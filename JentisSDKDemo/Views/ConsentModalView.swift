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
    @Binding var isAwinAllowed: Bool
    @State private var isGoogleAnalyticsNCM: Bool = false
    @State private var isFacebookNCM: Bool = false
    @State private var isAwinNCM: Bool = false
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
                consentToggle(title: "Google Analytics 4 Server-side", isOn: $isGoogleAnalyticsAllowed, ncmBinding: $isGoogleAnalyticsNCM, color: .blue)
                consentToggle(title: "Facebook", isOn: $isFacebookAllowed, ncmBinding: $isFacebookNCM, color: .indigo)
                consentToggle(title: "Google Ads", isOn: $isAwinAllowed, ncmBinding: $isAwinNCM, color: .green)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: saveConsents) {
                Text("Save Changes")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2, y: 2)
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
        userDefaults.set(isAwinAllowed, forKey: "isAwinAllowed")
        userDefaults.set(isGoogleAnalyticsNCM, forKey: "isGoogleAnalyticsNCM")
        userDefaults.set(isFacebookNCM, forKey: "isFacebookNCM")
        userDefaults.set(isAwinNCM, forKey: "isAwinNCM")

        // Map to ConsentStatus and pass to onSave
        let vendorConsents: [String: ConsentStatus] = [
            "google_analytics_4_server": isGoogleAnalyticsNCM ? .ncm : (isGoogleAnalyticsAllowed ? .allow : .deny),
            "facebook": isFacebookNCM ? .ncm : (isFacebookAllowed ? .allow : .deny),
            "adwords": isAwinNCM ? .ncm : (isAwinAllowed ? .allow : .deny)
        ]
        presentationMode.wrappedValue.dismiss()
        Task { await onSave(vendorConsents) }
    }
    
    private func loadConsents() {
        // Load saved values from UserDefaults
        isGoogleAnalyticsAllowed = userDefaults.bool(forKey: "isGoogleAnalyticsAllowed")
        isFacebookAllowed = userDefaults.bool(forKey: "isFacebookAllowed")
        isAwinAllowed = userDefaults.bool(forKey: "isAwinAllowed")
        isGoogleAnalyticsNCM = userDefaults.bool(forKey: "isGoogleAnalyticsNCM")
        isFacebookNCM = userDefaults.bool(forKey: "isFacebookNCM")
        isAwinNCM = userDefaults.bool(forKey: "isAwinNCM")
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
