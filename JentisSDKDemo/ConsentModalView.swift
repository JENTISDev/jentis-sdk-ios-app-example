//
//  ConsentModalView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 02/11/2024.
//
import SwiftUI

struct ConsentModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isGoogleAnalyticsAllowed: Bool
    @Binding var isFacebookAllowed: Bool
    @Binding var isAwinAllowed: Bool
    @State private var isGoogleAnalyticsNCM: Bool = false
    @State private var isFacebookNCM: Bool = false
    @State private var isAwinNCM: Bool = false

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
            
            // Toggles and NCM options
            VStack(spacing: 16) {
                consentToggle(title: "Google Analytics", isOn: $isGoogleAnalyticsAllowed, ncmBinding: $isGoogleAnalyticsNCM, color: .blue)
                consentToggle(title: "Facebook", isOn: $isFacebookAllowed, ncmBinding: $isFacebookNCM, color: .indigo)
                consentToggle(title: "Awin", isOn: $isAwinAllowed, ncmBinding: $isAwinNCM, color: .green)
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
    
    // Helper function for toggles with custom styling and NCM checkbox
    @ViewBuilder
    private func consentToggle(title: String, isOn: Binding<Bool>, ncmBinding: Binding<Bool>, color: Color) -> some View {
        HStack {
            Toggle(isOn: isOn) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .toggleStyle(SwitchToggleStyle(tint: color))
            
            Spacer()
            
            // NCM Checkbox
            HStack {
                Text("NCM")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Toggle("", isOn: ncmBinding)
                    .labelsHidden()
                    .toggleStyle(CheckboxToggleStyle())
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
