//
//  JentisSDKDemoApp.swift
//  JentisSDKDemo
//
//  Created by Alexandre Oliveira on 07/10/2024.
//

import SwiftUI
import netfox
import FirebaseCore
import JentisSDK
import AppTrackingTransparency
import Firebase

@main
struct JentisSDKDemoApp: App {
    // Link AppDelegate with the SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

// AppDelegate class to manage the application lifecycle and Netfox
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // #if DEBUG
        // Start Netfox only in debug mode
        NFX.sharedInstance().start()
        // #endif

        // Initialize Firebase
        FirebaseApp.configure()
        setupJentisSDK()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // #if DEBUG
        // Stop Netfox when the app is terminated
        NFX.sharedInstance().stop()
        // #endif
    }
    
    private func setupJentisSDK() {
        let savedConfig = UserDefaultsUtility.shared.get(key: "lastTrackConfig", type: TrackConfig.self)
        
        let config = savedConfig ?? TrackConfig(
            trackDomain: "qc3ipx.ckion-dev.jtm-demo.com", //"kndmjh.mipion.jtm-demo.com",
            container: "mipion-demo",
            environment: .live,
            version: "9",
            debugCode: "9983b926-e84e-46da-9f1b-3b495ab0ed4f",
            sessionTimeoutInSeconds: 1800,
            authorizationToken: "22fef7a3b00466743fee2ab8cd8afb01",
            enableOfflineTracking: true
        )
        
        JentisService.setLogLevel(.debug)
        JentisService.configure(with: config)
    }
}
