//
//  TrackingView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 09/11/2024.
//

import SwiftUI
import JentisSDK
import FirebasePerformance
import MetricKit
import Combine

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
    @State private var includeEnrichment: Bool = false
    @State private var customInitiator: String = ""
    @StateObject private var metricsManager = MetricsManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Title
                Text("Tracking Actions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(10)
                
                // Toggle for enrichment
                Toggle(isOn: $includeEnrichment) {
                    Text("Include Enrichment Data")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.mediumGray)
                }
                .padding(.horizontal)
                
                // Custom initiator input
                VStack(alignment: .leading, spacing: 15) {
                    Text("    Custom Initiator (Optional)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.mediumGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter custom initiator", text: $customInitiator)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.bottom, 5)
                
                // General Initiators Section
                Text("General Initiators")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                createTrackingButton(
                    title: "PageView",
                    color: .mainBlue,
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
                    color: .mainBlue,
                    actions: [
                        ["track": "pageview", "pagetitle": "Demo-APP Productview"],
                        ["track": "product", "type": "productview", "id": "123", "name": "Testproduct", "brutto": 199.99],
                        ["track": "productview"]
                    ],
                    snackbarMessage: "ProductView action sent successfully!",
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
                
                createTrackingButton(
                    title: "ProductView (Advanced)",
                    color: .mainBlue,
                    actions: [
                        ["track": "product", "type": "order", "id": "123", "name": "Testproduct", "brutto": 199.99],
                        ["track": "product", "type": "currentcart", "id": "777", "color": "green"],
                        ["track": "product", "type": "order", "id": "456", "name": "Testproduct 2", "brutto": 299.99]
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
                
                // E-commerce Initiators Section
                Text("E-commerce Initiators")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                createTrackingButton(
                    title: "Add-To-Cart",
                    color: .mainBlue,
                    actions: [],
                    snackbarMessage: "Add-To-Cart action sent successfully!",
                    showPopover: $showAddToCartPopover,
                    popoverText: """
                    // Add product to cart
                    let customProperties: [String: Any] = [
                        "id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ]

                    // Optionally add enrichment data
                    if includeEnrichment {
                        TrackingService.shared.addEnrichment(
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

                    // Add product to cart
                    TrackingService.shared.addToCart(customProperties)
                    """
                ) {
                    Task {
                        do {
                            let customProperties: [String: Any] = [
                                "id": "123",
                                "name": "Testproduct",
                                "brutto": 199.99
                            ]
                            if includeEnrichment {
                                try TrackingService.shared.addEnrichment(
                                    pluginId: "enrichment_xxxlprodfeed",
                                    arguments: ["accountId": "account", "page_title": "pagetitle", "productId": "product_id", "baseProductId": ["1"]],
                                    variables: ["enrichment_product_variant"]
                                )
                            }
                            try await TrackingService.shared.addToCart(customProperties)
                            snackbarMessage = "Add-To-Cart action sent successfully!"
                            isError = false
                            showSnackbarWithDelay()
                        } catch {
                            snackbarMessage = "Failed to send Add-To-Cart action"
                            isError = true
                            showSnackbarWithDelay()
                        }
                    }
                }
                
                createTrackingButton(
                    title: "Order",
                    color: .mainBlue,
                    actions: [
                        ["track": "pageview", "pagetitle": "Demo-APP Order Confirmed"],
                        ["track": "product", "type": "order", "product_id": "123", "name": "Testproduct", "brutto": 199.99],
                        ["track": "order", "order_id": "12345666", "brutto": 499.98, "paytype": "creditcard"]
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
                        "product_id": "123",
                        "name": "Testproduct",
                        "brutto": 199.99
                    ])
                    
                    TrackingService.shared.push([
                        "track": "order",
                        "order_id": "12345666",
                        "brutto": 499.98,
                        "paytype": "creditcard"
                    ])
                    """
                )
                
                // Enrichment Initiators Section
                Text("Enrichment Initiators")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                createTrackingButton(
                    title: "Custom Enrichment",
                    color: .mainBlue,
                    actions: [],
                    snackbarMessage: "Custom Enrichment sequence completed successfully!",
                    showPopover: $showCustomEnrichmentPopover,
                    popoverText: """
                    // Add custom enrichment
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
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .overlay(
            VStack {
                if showSnackbar {
                    HStack {
                        Image(systemName: isError ? "xmark.circle.fill" : "checkmark.circle.fill")
                            .foregroundColor(isError ? .red : .green)
                        Text(snackbarMessage)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(isError ? Color.red : Color.green)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                }
            }
                .animation(.easeInOut, value: showSnackbar)
                .transition(.move(edge: .bottom))
                .padding(.bottom, 20),
            alignment: .bottom
        )
    }
    
    private func createTrackingButton(
        title: String,
        color: Color,
        actions: [[String: Any]],
        snackbarMessage: String,
        showPopover: Binding<Bool>,
        popoverText: String,
        customAction: (() -> Void)? = nil
    ) -> some View {
        HStack {
            Button(action: {
                // Start Firebase trace
                let trace = Performance.startTrace(name: "\(title)_button_action")
                let cpuTimeInMilliseconds = Int64(metricsManager.cpuTime * 1000)
                print("CPU Time (ms): \(cpuTimeInMilliseconds)")
                trace?.incrementMetric("cumulative_cpu_time", by: cpuTimeInMilliseconds)

                if let customAction = customAction {
                    customAction()
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
                            
                            // Stop trace after action completes
                            trace?.stop()
                            
                            // Show success message
                            self.snackbarMessage = snackbarMessage
                            self.isError = false
                            showSnackbarWithDelay()
                        } catch {
                            // Stop trace in case of failure
                            trace?.stop()
                            
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

final class MetricsManager: NSObject, ObservableObject, MXMetricManagerSubscriber {
    @Published var cpuTime: Double = 0.0
    
    override init() {
        super.init()
        MXMetricManager.shared.add(self)
    }
    
    func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads {
            if let cpuMetrics = payload.cpuMetrics {
                DispatchQueue.main.async {
                    self.cpuTime = cpuMetrics.cumulativeCPUTime.converted(to: .seconds).value
                }
            }
        }
    }
}
