//
//  ConsentModalView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 02/11/2024.
//
import SwiftUI

// ConsentModalView for configuring vendors consent
struct ConsentModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isGoogleAnalyticsAllowed: Bool
    @Binding var isFacebookAllowed: Bool
    @Binding var isAwinAllowed: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
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
            
            // Toggles
            VStack(spacing: 16) {
                consentToggle(title: "Google Analytics", isOn: $isGoogleAnalyticsAllowed, color: .blue)
                consentToggle(title: "Facebook", isOn: $isFacebookAllowed, color: .indigo)
                consentToggle(title: "Awin", isOn: $isAwinAllowed, color: .green)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Save Button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
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
    }
    
    // Helper function for toggles with custom styling
    @ViewBuilder
    private func consentToggle(title: String, isOn: Binding<Bool>, color: Color) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .toggleStyle(SwitchToggleStyle(tint: color))
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
