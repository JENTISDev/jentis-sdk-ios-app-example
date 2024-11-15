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
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    @State private var isError: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Tracking Actions")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // PageView Button with Info Popover
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

            // Productview Button with Info Popover
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

            // Add-To-Cart Button with Info Popover
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

            // Order Button with Info Popover
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

            // New Example Button with Info Popover
            createTrackingButton(
                title: "New Example",
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
                        try await TrackingService.shared.submit()
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

    private func showSnackbarWithDelay() {
        showSnackbar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showSnackbar = false
        }
    }
}
