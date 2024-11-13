//
//  ConfigModalView.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 06/11/2024.
//

import SwiftUI
import JentisSDK

struct ConfigModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var trackDomain: String
    @State private var container: String
    @State private var environment: TrackConfig.Environment
    @State private var version: String
    @State private var debugCode: String
    @State private var sessionTimeout: String
    @State private var authorizationToken: String
    
    var onSave: ((TrackConfig) -> Void)
    
    init(onSave: @escaping ((TrackConfig) -> Void)) {
        let config = TrackConfig.currentConfig() ?? TrackConfig(
            trackDomain: "nd7cud.mobiweb.jtm-demo.com",
            container: "mobiweb-demoshop",
            environment: .live,
            version: "1",
            debugCode: "44c2acd3-434d-4234-983b-48e91551eb5a",
            sessionTimeoutInSeconds: 1800,
            authorizationToken: "22fef7a3b00466743fee2ab8cd8afb01"
        )
        
        _trackDomain = State(initialValue: config.trackDomain)
        _container = State(initialValue: config.container)
        _environment = State(initialValue: config.environment)
        _version = State(initialValue: config.version ?? "")
        _debugCode = State(initialValue: config.debugCode ?? "")
        _sessionTimeout = State(initialValue: String(config.sessionTimeoutInSeconds ?? 1800))
        _authorizationToken = State(initialValue: config.authorizationToken)
        
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Jentis SDK Configuration")) {
                    VStack(alignment: .leading) {
                        Text("Track Domain")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Track Domain", text: $trackDomain)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Container")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Container", text: $container)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Environment")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Picker("Environment", selection: $environment) {
                            Text("Live").tag(TrackConfig.Environment.live)
                            Text("Stage").tag(TrackConfig.Environment.stage)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Version")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Version", text: $version)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Debug Code")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Debug Code", text: $debugCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Session Timeout (seconds)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Session Timeout", text: $sessionTimeout)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Authorization Token")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Authorization Token", text: $authorizationToken)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Button("Save") {
                    let timeoutValue = TimeInterval(sessionTimeout) ?? 1800
                    let config = TrackConfig(
                        trackDomain: trackDomain,
                        container: container,
                        environment: environment,
                        version: version,
                        debugCode: debugCode,
                        sessionTimeoutInSeconds: timeoutValue,
                        authorizationToken: authorizationToken
                    )
                    
                    onSave(config)
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Configuration")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
