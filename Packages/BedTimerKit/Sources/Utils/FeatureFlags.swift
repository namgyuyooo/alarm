import Foundation

public struct FeatureFlags {
    public static let shared = FeatureFlags()
    
    private init() {}
    
    // MARK: - Ad Features
    public var adsEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["ENABLE_ADS"] == "YES"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "ENABLE_ADS") as? Bool ?? false
        #endif
    }
    
    // MARK: - Cloud Sync
    public var cloudSyncEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["ENABLE_CLOUD_SYNC"] == "YES"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "ENABLE_CLOUD_SYNC") as? Bool ?? false
        #endif
    }
    
    // MARK: - HealthKit Integration
    public var healthKitEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["FEATURE_HEALTH_KIT"] == "YES"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "FEATURE_HEALTH_KIT") as? Bool ?? false
        #endif
    }
    
    // MARK: - Gamification
    public var gamificationEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["FEATURE_GAMIFICATION"] == "YES"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "FEATURE_GAMIFICATION") as? Bool ?? false
        #endif
    }
    
    // MARK: - Export Features
    public var exportEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["FEATURE_EXPORT"] == "YES"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "FEATURE_EXPORT") as? Bool ?? false
        #endif
    }
    
    // MARK: - Analytics
    public var analyticsEnabled: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["ENABLE_ANALYTICS"] == "YES"
        #else
        return Bundle.main.object(forInfoDictionaryKey: "ENABLE_ANALYTICS") as? Bool ?? false
        #endif
    }
    
    // MARK: - Debug Features
    public var debugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Build Configuration
    public var buildConfiguration: BuildConfiguration {
        #if DEBUG
        return .debug
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
}

public enum BuildConfiguration: String, CaseIterable {
    case debug = "DEBUG"
    case staging = "STAGING"
    case production = "PRODUCTION"
    
    public var displayName: String {
        switch self {
        case .debug:
            return "Development"
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        }
    }
    
    public var isDebug: Bool {
        return self == .debug
    }
    
    public var isRelease: Bool {
        return self == .production
    }
}

// MARK: - Feature Flag Extensions
public extension FeatureFlags {
    /// 특정 기능이 활성화되어 있는지 확인
    func isFeatureEnabled(_ feature: Feature) -> Bool {
        switch feature {
        case .ads:
            return adsEnabled
        case .cloudSync:
            return cloudSyncEnabled
        case .healthKit:
            return healthKitEnabled
        case .gamification:
            return gamificationEnabled
        case .export:
            return exportEnabled
        case .analytics:
            return analyticsEnabled
        }
    }
    
    /// 모든 활성화된 기능 목록
    var enabledFeatures: [Feature] {
        return Feature.allCases.filter { isFeatureEnabled($0) }
    }
}

public enum Feature: String, CaseIterable {
    case ads = "ads"
    case cloudSync = "cloud_sync"
    case healthKit = "health_kit"
    case gamification = "gamification"
    case export = "export"
    case analytics = "analytics"
    
    public var displayName: String {
        switch self {
        case .ads:
            return "Advertisements"
        case .cloudSync:
            return "Cloud Sync"
        case .healthKit:
            return "HealthKit Integration"
        case .gamification:
            return "Gamification"
        case .export:
            return "Data Export"
        case .analytics:
            return "Analytics"
        }
    }
}