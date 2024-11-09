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
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    @State private var isError: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Tracking Actions")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            HStack {
                Button(action: {
                    TrackingService.shared.push([
                        "track": "pageview",
                        "pagetitle": "Demo-APP Pagetitle",
                        "url": "https://www.demoapp.com"
                    ])
                    Task {
                        try await TrackingService.shared.submit()
                        snackbarMessage = "PageView action sent successfully!"
                        isError = false
                        showSnackbarWithDelay()
                    }
                }) {
                    Text("PageView")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    showPageViewPopover.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .popover(isPresented: $showPageViewPopover) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to track PageView:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("""
                        TrackingService.shared.push([
                            "track": "pageview",
                            "pagetitle": "Demo-APP Pagetitle",
                            "url": "https://www.demoapp.com"
                        ])
                        """)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)

                        Text("How to submit:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        Text("TrackingService.shared.submit()")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }

            // Productview Button with Info Popover
            HStack {
                Button(action: {
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
                    Task {
                        try await TrackingService.shared.submit()
                        snackbarMessage = "Productview action sent successfully!"
                        isError = false
                        showSnackbarWithDelay()
                    }
                }) {
                    Text("Productview")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    showProductViewPopover.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .popover(isPresented: $showProductViewPopover) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to track Productview:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("""
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
                        """)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)

                        Text("How to submit:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        Text("TrackingService.shared.submit()")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }

            // Add-To-Cart Button with Info Popover
            HStack {
                Button(action: {
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
                    Task {
                        try await TrackingService.shared.submit()
                        snackbarMessage = "Add-To-Cart action sent successfully!"
                        isError = false
                        showSnackbarWithDelay()
                    }
                }) {
                    Text("Add-To-Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    showAddToCartPopover.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .popover(isPresented: $showAddToCartPopover) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to track Add-To-Cart:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("""
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
                        """)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)

                        Text("How to submit:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        Text("TrackingService.shared.submit()")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }

            // Order Button with Info Popover
            HStack {
                Button(action: {
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
                        "paytype": "creditcart"
                    ])
                    Task {
                        try await TrackingService.shared.submit()
                        snackbarMessage = "Order action sent successfully!"
                        isError = false
                        showSnackbarWithDelay()
                    }
                }) {
                    Text("Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    showOrderPopover.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .popover(isPresented: $showOrderPopover) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to track Order:")
                            .font(.headline)
                            .padding(.bottom, 5)
                        Text("""
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
                            "paytype": "creditcart"
                        ])
                        """)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)

                        Text("How to submit:")
                            .font(.headline)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                        Text("TrackingService.shared.submit()")
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }

    private func showSnackbarWithDelay() {
        showSnackbar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showSnackbar = false
        }
    }
}
