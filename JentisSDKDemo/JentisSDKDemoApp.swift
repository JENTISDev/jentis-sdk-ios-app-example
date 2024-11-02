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
        let config = TrackConfig(
            trackDomain: "nd7cud.mobiweb.jtm-demo.com",
            container: "mobiweb-demoshop",
            environment: .live,
            version: "1",
            debugCode: "44c2acd3-434d-4234-983b-48e91551eb5a"
        )
        
        JentisService.configure(with: config)
    }
}
