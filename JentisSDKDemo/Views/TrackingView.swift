//
//  TrackingView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 09/11/2024.
//

import SwiftUI
import JentisSDK

struct TrackingView: View {
    @State private var showPageViewPopover = false
    @State private var showProductViewPopover = false
    @State private var showAddToCartPopover = false
    @State private var showOrderPopover = false
    @State private var showNewExamplePopover = false
    @State private var showCustomEnrichmentPopover = false
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    @State private var isError: Bool = false
    @State private var includeEnrichment: Bool = false // Checkbox state
    @State private var customInitiator: String = ""
    
    var enrichmentData: [String: Any] {
        [
            "enrichment": [
                "enrichment_xxxlprodfeed": [
                    "variables": ["enrichment_product_variant"],
                    "arguments": [
                        "account": "account",
                        "baseProductId": ["1"],
                        "page_title": "pagetitle",
                        "productId": "product_id"
                    ]
                ]
            ]
        ]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tracking Actions")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Enrichment toggle
            Toggle(isOn: $includeEnrichment) {
                Text("Include Enrichment Data")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            // Custom initiator input
            VStack(alignment: .leading, spacing: 10) {
                Text("Custom Initiator (Optional)")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter custom initiator", text: $customInitiator)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            
            // Buttons
            createTrackingButton(
                title: "PageView",
                color: .blue,
                actions: [
                    [
                        "track": "pageview",
                        "pagetitle": "Demo-APP Pagetitle",
                        "url": "https://www.demoapp.com"
                    ]
                ],
                snackbarMessage: "PageView action sent successfully!",
                showPopover: $showPageViewPopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "pageview",
                        "pagetitle": "Demo-APP Pagetitle",
                        "url": "https://www.demoapp.com"
                    ])
                """
            )
            
            createTrackingButton(
                title: "ProductView",
                color: .purple,
                actions: [
                    [
                        "track": "pageview",
                        "pagetitle": "Demo-APP Productview"
                    ],
                    [
                        "track": "product",
                        "type": "productview",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ],
                    [
                        "track": "productview"
                    ]
                ],
                snackbarMessage: "ProductView action sent successfully!",
                showPopover: $showProductViewPopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "productview",
                        "type": "productview",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                """
            )
            
            createTrackingButton(
                title: "Add-To-Cart",
                color: .green,
                actions: [],
                snackbarMessage: "Add-To-Cart action sent successfully!",
                showPopover: $showAddToCartPopover,
                popoverText: """
                    TrackingService.shared.addToCart([
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                """
            ) {
                Task {
                    do {
                        // Prepare the payload for Add-To-Cart
                        let customProperties: [String: Any] = [
                            "id": "123",
                            "name": "Testproduct",
                            "brutto": 199.99
                        ]
                        
                        // Add enrichment if toggled on
                        if includeEnrichment {
                            try await TrackingService.shared.addEnrichment(
                                pluginId: "enrichment_xxxlprodfeed",
                                arguments: [
                                    "accountId": "account",
                                    "page_title": "pagetitle",
                                    "productId": "product_id",
                                    "baseProductId": ["1"]
                                ],
                                variables: ["enrichment_product_variant"]
                            )
                        }
                        
                        // Use the addToCart method to submit the action
                        try await TrackingService.shared.addToCart(customProperties)
                        
                        // Show success message
                        snackbarMessage = "Add-To-Cart action sent successfully!"
                        isError = false
                        showSnackbarWithDelay()
                    } catch {
                        // Handle errors
                        snackbarMessage = "Failed to send Add-To-Cart action"
                        isError = true
                        showSnackbarWithDelay()
                    }
                }
            }
            
            createTrackingButton(
                title: "Order",
                color: .orange,
                actions: [
                    [
                        "track": "pageview",
                        "pagetitle": "Demo-APP Order Confirmed"
                    ],
                    [
                        "track": "product",
                        "type": "order",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ],
                    [
                        "track": "product",
                        "type": "currentcart",
                        "id": "777",
                        "color": "green"
                    ],
                    [
                        "track": "product",
                        "type": "order",
                        "id": "456",
                        "name": "Testproduct 2",
                        "brutto": 299.99
                    ],
                    [
                        "track": "order",
                        "order_id": "12345666",
                        "brutto": 499.98,
                        "paytype": "creditcard"
                    ]
                ],
                snackbarMessage: "Order action sent successfully!",
                showPopover: $showOrderPopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "order",
                        "order_id": "12345666",
                        "brutto": 499.98,
                        "paytype": "creditcard"
                    ])
                """
            )
            
            createTrackingButton(
                title: "ProductView (Advanced)",
                color: .pink,
                actions: [
                    [
                        "track": "product",
                        "type": "order",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ],
                    [
                        "track": "product",
                        "type": "currentcart",
                        "id": "777",
                        "color": "green"
                    ],
                    [
                        "track": "product",
                        "type": "order",
                        "id": "456",
                        "name": "Testproduct 2",
                        "brutto": 299.99
                    ]
                ],
                snackbarMessage: "ProductView (Advanced) action sent successfully!",
                showPopover: $showNewExamplePopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "order",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                """
            )
            
            createTrackingButton(
                title: "Custom Enrichment",
                color: .gray,
                actions: [],
                snackbarMessage: "Custom Enrichment sequence completed successfully!",
                showPopover: $showCustomEnrichmentPopover,
                popoverText: """
                    TrackingService.shared.addCustomEnrichment(
                        pluginId: "enrichment_xxxlprodfeed",
                        arguments: [
                            "account": "account",
                            "page_title": "pagetitle",
                            "productId": "product_id",
                            "baseProductId": ["1"]
                        ],
                        variables: ["enrichment_product_variant"]
                    )
                """
            )
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func createTrackingButton(
        title: String,
        color: Color,
        actions: [[String: Any]],
        snackbarMessage: String,
        showPopover: Binding<Bool>,
        popoverText: String,
        customAction: (() -> Void)? = nil // Add an optional customAction parameter
    ) -> some View {
        HStack {
            Button(action: {
                if let customAction = customAction {
                    customAction() // Execute the custom closure if provided
                } else {
                    Task {
                        do {
                            // Initialize base tracking actions
                            let enrichedActions = actions
                            
                            // Push actions sequentially
                            for action in enrichedActions {
                                try await TrackingService.shared.push(action)
                            }
                            
                            // If enrichment is enabled, add enrichment data explicitly
                            if includeEnrichment {
                                try await TrackingService.shared.addEnrichment(
                                    pluginId: "enrichment_xxxlprodfeed",
                                    arguments: [
                                        "accountId": "account",
                                        "page_title": "pagetitle",
                                        "productId": "product_id",
                                        "baseProductId": ["1"]
                                    ],
                                    variables: ["enrichment_product_variant"]
                                )
                            }
                            
                            // Submit the data
                            if customInitiator.isEmpty {
                                try await TrackingService.shared.submit()
                            } else {
                                try await TrackingService.shared.submit(customInitiator)
                            }
                            
                            // Show success message
                            self.snackbarMessage = snackbarMessage
                            self.isError = false
                            showSnackbarWithDelay()
                        } catch {
                            // Handle errors
                            self.snackbarMessage = "Failed to send \(title) action"
                            self.isError = true
                            showSnackbarWithDelay()
                        }
                    }
                }
            }) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(color)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                showPopover.wrappedValue.toggle()
            }) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .popover(isPresented: showPopover) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("How to track \(title):")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text(popoverText)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)
                }
                .padding()
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
