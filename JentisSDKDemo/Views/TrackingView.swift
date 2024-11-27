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
    @State private var showEnrichmentPopover = false // New enrichment popover state
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    @State private var isError: Bool = false
    @State private var customInitiator: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tracking Actions")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Custom Initiator (Optional)")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter custom initiator", text: $customInitiator)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            
            // PageView Button
            createTrackingButton(
                title: "PageView",
                color: .blue,
                actions: [
                    [
                        "track": "pageview",
                        "pagetitle": "Demo-APP Pagetitle",
                        "url": "https://www.demoapp.com",
                        "document_title": "Demo-APP Document Title",
                        "virtualPagePath": "Track Pageview",
                        "window_location_href": "https://mipion.jtm-demo.com/NEWiostest"
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
            
            // Productview Button
            createTrackingButton(
                title: "Productview",
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
                snackbarMessage: "Productview action sent successfully!",
                showPopover: $showProductViewPopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "pageview",
                        "pagetitle": "Demo-APP Productview"
                    ])
                
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "productview",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                
                    TrackingService.shared.push([
                        "track": "productview"
                    ])
                """
            )
            
            // Add-To-Cart Button
            createTrackingButton(
                title: "Add-To-Cart",
                color: .green,
                actions: [
                    [
                        "track": "product",
                        "type": "addtocart",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ],
                    [
                        "track": "addtocart"
                    ]
                ],
                snackbarMessage: "Add-To-Cart action sent successfully!",
                showPopover: $showAddToCartPopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "addtocart",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                
                    TrackingService.shared.push([
                        "track": "addtocart"
                    ])
                """
            )
            
            // Order Button
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
                        "orderid": "12345666",
                        "brutto": 499.98,
                        "paytype": "creditcard"
                    ]
                ],
                snackbarMessage: "Order action sent successfully!",
                showPopover: $showOrderPopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "pageview",
                        "pagetitle": "Demo-APP Order Confirmed"
                    ])
                
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "order",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "currentcart",
                        "id": "777",
                        "color": "green"
                    ])
                
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "order",
                        "id": "456",
                        "name": "Testproduct 2",
                        "brutto": 299.99
                    ])
                
                    TrackingService.shared.push([
                        "track": "order",
                        "orderid": "12345666",
                        "brutto": 499.98,
                        "paytype": "creditcard"
                    ])
                """
            )
            
            // ProductView (Advanced) Button
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
                snackbarMessage: "New example sent successfully!",
                showPopover: $showNewExamplePopover,
                popoverText: """
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "order",
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "currentcart",
                        "id": "777",
                        "color": "green"
                    ])
                
                    TrackingService.shared.push([
                        "track": "product",
                        "type": "order",
                        "id": "456",
                        "name": "Testproduct 2",
                        "brutto": 299.99
                    ])
                """
            )
            
            // Add Enrichment Button
            createEnrichmentButton(
                title: "Add Enrichment",
                color: .red,
                enrichmentData: [
                    "pluginId": "enrichment_xxxlprodfeed",
                    "arguments": [
                        "account": "JENTIS TEST ACCOUNT",
                        "page_title": "Demo-APP Order Confirmed",
                        "productId": ["123", "777", "456"],
                        "baseProductId": ["1"]
                    ],
                    "variables": ["enrichment_product_variant"]
                ],
                snackbarMessage: "Enrichment added and submitted successfully!",
                showPopover: $showEnrichmentPopover,
                popoverText: """
                    TrackingService.shared.addEnrichment(
                        pluginId: "enrichment_xxxlprodfeed",
                        arguments: [
                            "account": "JENTIS TEST ACCOUNT",
                            "page_title": "Demo-APP Order Confirmed",
                            "productId": ["123", "777", "456"],
                            "baseProductId": ["1"]
                        ],
                        variables: ["enrichment_product_variant"]
                    )
                    TrackingService.shared.submit()
                """
            )
            
            // Custom Enrichment Button
            createCustomEnrichmentButton(
                title: "Custom Enrichment",
                color: .gray,
                showPopover: $showEnrichmentPopover,
                snackbarMessage: "Custom enrichment sequence completed successfully!",
                popoverText: """
                    TrackingService.shared.push([
                      "track": "pageview",
                      "pagetitle": "Demo-APP Order Confirmed",
                      "account": "JENTIS TEST ACCOUNT"
                    ]);
                
                    TrackingService.shared.push([
                      "track": "product",
                      "type": "order",
                      "id": "123",
                      "name": "Testproduct",
                      "brutto": 199.99
                    ]);
                
                    TrackingService.shared.push([
                      "track": "product",
                      "type": "currentcart",
                      "id": "777",
                      "color": "green"
                    ]);
                
                    TrackingService.shared.push([
                      "track": "product",
                      "type": "order",
                      "id": "456",
                      "name": "Testproduct 2",
                      "brutto": 299.99
                    ]);
                
                    TrackingService.shared.push([
                      "track": "order",
                      "orderid": "12345666",
                      "brutto": 499.98,
                      "paytype": "creditcart"
                    ]);
                
                    TrackingService.shared.addCustomEnrichment(
                      pluginId: "enrichment_xxxlprodfeed",
                      arguments: [
                        "account": .string("TESTACCOUNT"),
                        "page_title": .string("MY PAGE TITLE"),
                        "productId": .array(["1", "ABC", "3"].map { .string($0) }),
                        "baseProductId": ["1"]
                      ],
                      variables: ["enrichment_product_variant"]
                    );
                
                    TrackingService.shared.submit()
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
        popoverText: String
    ) -> some View {
        HStack {
            Button(action: {
                Task {
                    do {
                        for action in actions {
                            try await TrackingService.shared.push(action)
                        }
                        if customInitiator.isEmpty {
                            try await TrackingService.shared.submit()
                        } else {
                            try await TrackingService.shared.submit(customInitiator)
                        }
                        self.snackbarMessage = snackbarMessage
                        self.isError = false
                        showSnackbarWithDelay()
                    } catch {
                        self.snackbarMessage = "Failed to send \(title) action"
                        self.isError = true
                        showSnackbarWithDelay()
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
    
    private func createEnrichmentButton(
        title: String,
        color: Color,
        enrichmentData: [String: Any],
        snackbarMessage: String,
        showPopover: Binding<Bool>,
        popoverText: String
    ) -> some View {
        HStack {
            Button(action: {
                Task {
                    do {
                        let pluginId = enrichmentData["pluginId"] as? String ?? "unknownPlugin"
                        let arguments = enrichmentData["arguments"] as? [String: Any] ?? [:]
                        let variables = enrichmentData["variables"] as? [String] ?? []
                        
                        try await TrackingService.shared.addEnrichment(
                            pluginId: pluginId,
                            arguments: arguments,
                            variables: variables
                        )
                        
                        try await TrackingService.shared.submit(customInitiator)
                        
                        self.snackbarMessage = snackbarMessage
                        self.isError = false
                        showSnackbarWithDelay()
                    } catch {
                        self.snackbarMessage = "Failed to add enrichment and submit"
                        self.isError = true
                        showSnackbarWithDelay()
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
                    Text("How to add \(title):")
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
    
    private func createCustomEnrichmentButton(
        title: String,
        color: Color,
        showPopover: Binding<Bool>,
        snackbarMessage: String,
        popoverText: String
    ) -> some View {
        HStack {
            Button(action: {
                Task {
                    do {
                        // Step 1: Push the PageView data
                        try await TrackingService.shared.push([
                            "track": "pageview",
                            "pagetitle": "Demo-APP Order Confirmed",
                            "account": "JENTIS TEST ACCOUNT"
                        ])
                        
                        // Step 2: Push the first product order
                        try await TrackingService.shared.push([
                            "track": "product",
                            "type": "order",
                            "id": "123",
                            "name": "Testproduct",
                            "brutto": 199.99
                        ])
                        
                        // Step 3: Push the current cart data
                        try await TrackingService.shared.push([
                            "track": "product",
                            "type": "currentcart",
                            "id": "777",
                            "color": "green"
                        ])
                        
                        // Step 4: Push the second product order
                        try await TrackingService.shared.push([
                            "track": "product",
                            "type": "order",
                            "id": "456",
                            "name": "Testproduct 2",
                            "brutto": 299.99
                        ])
                        
                        // Step 5: Push the order details
                        try await TrackingService.shared.push([
                            "track": "order",
                            "orderid": "12345666",
                            "brutto": 499.98,
                            "paytype": "creditcart"
                        ])
                        
                        // Step 6: Add the custom enrichment
                        TrackingService.shared.addCustomEnrichment(
                            pluginId: "enrichment_xxxlprodfeed",
                            arguments: [
                                "account": .string("TESTACCOUNT"),
                                "page_title": .string("MY PAGE TITLE"),
                                "productId": .array(["1", "ABC", "3"].map { .string($0) }),
                                "baseProductId": .array(["1"].map { .string($0) }),
                            ],
                            variables: ["enrichment_product_variant"]
                        )
                        
                        // Step 7: Submit all the data
                        try await TrackingService.shared.submit(customInitiator)
                        
                        // Display success snackbar
                        self.snackbarMessage = snackbarMessage
                        self.isError = false
                        showSnackbarWithDelay()
                    } catch {
                        // Handle error
                        self.snackbarMessage = "Failed to perform custom enrichment actions"
                        self.isError = true
                        showSnackbarWithDelay()
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
                    Text("How to perform \(title):")
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
