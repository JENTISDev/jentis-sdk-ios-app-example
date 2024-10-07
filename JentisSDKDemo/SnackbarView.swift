//
//  SnackbarView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 07/10/2024.
//

import Foundation
import SwiftUI

struct SnackbarView: View {
    let message: String
    let isError: Bool

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isError ? Color.red : Color.green)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
    }
}

