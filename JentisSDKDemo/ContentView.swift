//
//  ContentView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 07/10/2024.
//

import SwiftUI
import JentisSDK

struct ContentView: View {
    @State private var message: String = ""
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    @State private var isError: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Jentis SDK Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Enter a message to log it to the server.")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                TextField("Enter your message here...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    saveMessage()
                }) {
                    Text("Send Message")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

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

    private func saveMessage() {
        Task {
            do {
                try await TrackingService.saveString(message)
                DispatchQueue.main.async {
                    snackbarMessage = "String stored successfully!"
                    isError = false
                    showSnackbarWithDelay()
                }
            } catch {
                DispatchQueue.main.async {
                    snackbarMessage = message.isEmpty ? "Parameter \"myString\" not provided" : "Failed to send message."
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
