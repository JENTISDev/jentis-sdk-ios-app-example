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
    @State private var customProtocol: String
    @State private var enableOfflineTracking: Bool
    
    var onSave: ((TrackConfig) -> Void)
    
    init(onSave: @escaping ((TrackConfig) -> Void)) {
        let savedConfig = UserDefaultsUtility.shared.get(key: "lastTrackConfig", type: TrackConfig.self)
        
        let config = savedConfig ?? TrackConfig(
            trackDomain: "qc3ipx.ckion-dev.jtm-demo.com",
            container: "mipion-demo",
            environment: .live,
            version: "9",
            debugCode: "9983b926-e84e-46da-9f1b-3b495ab0ed4f",
            sessionTimeoutInSeconds: 1800,
            authorizationToken: "22fef7a3b00466743fee2ab8cd8afb01",
            customProtocol: "https",
            enableOfflineTracking: true
        )
        
        _trackDomain = State(initialValue: config.trackDomain)
        _container = State(initialValue: config.container)
        _environment = State(initialValue: config.environment)
        _version = State(initialValue: config.version ?? "")
        _debugCode = State(initialValue: config.debugCode ?? "")
        _sessionTimeout = State(initialValue: String(config.sessionTimeoutInSeconds ?? 1800))
        _authorizationToken = State(initialValue: config.authorizationToken)
        _customProtocol = State(initialValue: config.customProtocol ?? "https")
        _enableOfflineTracking = State(initialValue: config.enableOfflineTracking)
        
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
                    
                    VStack(alignment: .leading) {
                        Text("Custom Protocol (http/https)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Custom Protocol", text: $customProtocol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Toggle(isOn: $enableOfflineTracking) {
                        Text("Enable Offline Tracking")
                    }
                }
                
                Button("Save") {
                    let timeoutValue = TimeInterval(sessionTimeout) ?? 1800
                    let config = TrackConfig(
                        trackDomain: trackDomain,
                        container: container,
                        environment: environment,
                        version: version.isEmpty ? nil : version,
                        debugCode: debugCode.isEmpty ? nil : debugCode,
                        sessionTimeoutInSeconds: timeoutValue,
                        authorizationToken: authorizationToken,
                        customProtocol: customProtocol,
                        enableOfflineTracking: enableOfflineTracking
                    )
                    
                    // Save the configuration to UserDefaults
                    UserDefaultsUtility.shared.save(key: "lastTrackConfig", value: config)
                    
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
