//
//  TrackingService.swift
//  JentisSDK
//
//  Created by Alexandre Oliveira on 07/10/2024.
//

import Foundation

public class JentisService {
    public static func configure(with config: TrackConfig) {
        LoggerUtility.shared.logInfo("JentisService is configuring with trackDomain: \(config.trackDomain), container: \(config.container), environment: \(config.environment.rawValue)")

        // Always set the new TrackConfig
        TrackConfig.configure(
            trackDomain: config.trackDomain,
            container: config.container,
            environment: config.environment,
            version: config.version,
            debugCode: config.debugCode
        )

        // Reinitialize TrackingService each time JentisService is configured
        TrackingService.resetInstance()
        TrackingService.initialize()

        SessionManager.startObservingAppLifecycle()
    }
}

public class TrackingService {
    private static var instance: TrackingService?
    
    public static func initialize() {
        guard instance == nil else {
            LoggerUtility.shared.logWarning("TrackingService is already initialized")
            return
        }
        
        let trackConfig = TrackConfig.shared
        let userIDUtility = UserIDUtility(userIDKey: "\(trackConfig.container)_userID")
        let consentIDUtility = ConsentIDUtility(consentIDKey: "\(trackConfig.container)_consentID")
        
        instance = TrackingService(userIDUtility: userIDUtility, consentIDUtility: consentIDUtility)
        LoggerUtility.shared.logInfo("TrackingService initialized successfully with container: \(trackConfig.container)")
    }
    
    public static var shared: TrackingService {
        guard let instance = instance else {
            LoggerUtility.shared.logError("TrackingService is not initialized. Call JentisService.configure(with:) first.")
            fatalError("TrackingService is not initialized. Call JentisService.configure(with:) first.")
        }
        return instance
    }
    
    // Reset the singleton instance
    public static func resetInstance() {
        instance = nil
        LoggerUtility.shared.logInfo("TrackingService instance has been reset.")
    }
    
    private let trackConfig = TrackConfig.shared
    private var service = Service()
    private let userAgent = UserAgentUtility.userAgent
    private let consentUtility: ConsentIDUtility
    private let userIDUtility: UserIDUtility
    
    private init(userIDUtility: UserIDUtility, consentIDUtility: ConsentIDUtility) {
        self.userIDUtility = userIDUtility
        self.consentUtility = consentIDUtility
    }
    
    internal func setService(_ mockService: Service) {
        self.service = mockService
    }
    
    public func setConsents(vendorConsents: [String: ConsentStatus], vendorChanges: [String: ConsentStatus]) async -> Result<Bool, Error> {
        do {
            LoggerUtility.shared.logInfo("Preparing to send consent model")
            
            let (userID, userAction) = userIDUtility.getUserIDWithAction()
            let (consentID, consentAction) = consentUtility.getConsentIDWithAction()
            
            // Map `vendorConsents` and `vendorChanges` to `[String: VendorValue]`
            let vendorConsentsMapped = vendorConsents.mapValues { $0.toVendorValue }
            let vendorChangesMapped = vendorChanges.mapValues { $0.toVendorValue }
            
            let consentModel = ConsentModel(
                version: "3",
                system: ConsentModel.System(
                    type: Config.Tracking.systemEnvironment,
                    timestamp: TimestampUtility.currentTimestampInMillis(),
                    navigatorUserAgent: userAgent,
                    initiator: Config.Tracking.pluginId
                ),
                configuration: ConsentModel.Configuration(
                    container: trackConfig.container,
                    environment: trackConfig.environment.rawValue,
                    version: trackConfig.version ?? "",
                    debugcode: trackConfig.debugCode ?? ""
                ),
                data: ConsentModel.DataClass(
                    identifier: ConsentModel.DataClass.Identifier(
                        user: ConsentModel.DataClass.Identifier.User(
                            id: userID,
                            action: userAction.rawValue
                        ),
                        consent: ConsentModel.DataClass.Identifier.ConsentID(
                            id: consentID,
                            action: consentAction.rawValue
                        )
                    ),
                    consent: ConsentModel.DataClass.Consent(
                        lastupdate: TimestampUtility.currentTimestampInMillis(),
                        data: [:],
                        vendors: vendorConsentsMapped,
                        vendorsChanged: vendorChangesMapped
                    )
                )
            )
            
            LoggerUtility.shared.logDebug("Sending consent model: \(consentModel)")
            try await service.sendConsent(consentModel)
            LoggerUtility.shared.logInfo("Consent model sent successfully")
            return .success(true)
            
        } catch {
            LoggerUtility.shared.logError("Failed to send consent model: \(error)")
            return .failure(error)
        }
    }
    
    public func sendDataSubmissionModel(variables: VariablesWrapper? = nil) async throws {
        LoggerUtility.shared.logInfo("Preparing to send data submission model")
        
        // Retrieve necessary IDs and actions
        let (userID, userAction) = userIDUtility.getUserIDWithAction()
        let (sessionID, sessionAction) = SessionManager.startOrResumeSession()
        
        // Use provided variables from wrapper or default values
        let submissionVariables = variables?.toDataSubmissionModelVariables() ?? DataSubmissionModel.DataClass.Variables(
            documentLocationHref: "https://ckion-dev.jtm-demo.com/?",
            fbBrowserId: "fb.1.1711009849625.5246926883",
            jtspushedcommands: [Config.Tracking.Track.pageview.rawValue, Config.Tracking.Track.submit.rawValue],
            productId: ["1111", "2222222"]
        )

        // Prepare the DataSubmissionModel
        let dataSubmissionModel = DataSubmissionModel(
            version: "3",
            system: DataSubmissionModel.System(
                type: Config.Tracking.systemEnvironment,
                timestamp: TimestampUtility.currentTimestampInMillis(),
                navigatorUserAgent: userAgent,
                initiator: Config.Tracking.pluginId,
                sessionID: sessionID
            ),
            consent: DataSubmissionModel.Consent(
                googleAnalytics: DataSubmissionModel.Consent.Vendor(status: .string("ncm")),
                facebook: DataSubmissionModel.Consent.Vendor(status: .bool(true)),
                awin: DataSubmissionModel.Consent.Vendor(status: .bool(false))
            ),
            configuration: DataSubmissionModel.Configuration(
                container: trackConfig.container,
                environment: trackConfig.environment.rawValue,
                version: trackConfig.version ?? "",
                debugcode: trackConfig.debugCode ?? ""
            ),
            data: DataSubmissionModel.DataClass(
                identifier: DataSubmissionModel.DataClass.Identifier(
                    user: DataSubmissionModel.DataClass.Identifier.User(
                        id: userID,
                        action: userAction.rawValue
                    ),
                    session: DataSubmissionModel.DataClass.Identifier.Session(
                        id: sessionID,
                        action: sessionAction.rawValue
                    )
                ),
                variables: submissionVariables,
                enrichment: DataSubmissionModel.DataClass.Enrichment(
                    enrichmentXxxlprodfeed: DataSubmissionModel.DataClass.Enrichment.EnrichmentXxxlprodfeed(
                        arguments: DataSubmissionModel.DataClass.Enrichment.EnrichmentXxxlprodfeed.Arguments(
                            account: "xxxlutz-de",
                            productId: ["12345"],
                            baseProductId: ["1"]
                        ),
                        variables: ["enrich_product_price", "enrich_product_brand", "enrich_product_name"]
                    )
                )
            )
        )
        
        LoggerUtility.shared.logDebug("Sending data submission model: \(dataSubmissionModel)")
        try await service.sendDataSubmission(dataSubmissionModel)
        LoggerUtility.shared.logInfo("Data submission model sent successfully")
    }

}

// MARK: - Push
private let trackCommand = "defaultTrackCommand"
private let typeValue = "defaultDependencyType"

extension TrackingService {        

    public func push(customProperties: [String: Any]) {
        // Extract track and type values from customProperties if available
        let track = customProperties["track"] as? String ?? trackCommand
        let type = customProperties["type"] as? String ?? typeValue
        
        // Filter out non-string values and reserved keys
        var filteredProperties: [String: String] = [:]
        for (key, value) in customProperties {
            if key != "track" && key != "type", let stringValue = value as? String {
                filteredProperties[key] = stringValue
            }
        }
        
        let payload = PushPayload(
            track: track,
            type: type,
            customProperties: filteredProperties
        )
        
        LoggerUtility.shared.logInfo("Pushing data with payload: \(payload)")
        
        // Save to UserDefaults as part of the list
        UserDefaultsUtility.savePush(payload)
    }
    
    public func submit() async throws {
        LoggerUtility.shared.logInfo("Submitting data with stored push data")
        
        // Retrieve all stored push data
        let pushList = UserDefaultsUtility.getPushList()
        
        // Compile custom properties and track commands
        var customVariables: [String: String] = [:]
        var pushedCommands: [String] = []

        for push in pushList {
            for (key, value) in push.customProperties {
                // Overwrite the existing value if the key is repeated
                customVariables[key] = value
            }
            // Collect track commands for each push
            pushedCommands.append(push.track)
        }

        // Manually add the "submit" event at the end of jtspushedcommands
        pushedCommands.append("submit")
        
        // Create VariablesWrapper including both default and custom properties
        let submissionVariables = VariablesWrapper(
            documentLocationHref: "https://ckion-dev.jtm-demo.com/?",
            fbBrowserId: "fb.1.1711009849625.5246926883",
            jtspushedcommands: pushedCommands,
            productId: ["1111", "2222222"],
            customProperties: customVariables
        )

        // Send data submission with the combined variables
        try await TrackingService.shared.sendDataSubmissionModel(variables: submissionVariables)

        // Clear the stored push list after submission
        UserDefaultsUtility.clearPushList()
    }
}
