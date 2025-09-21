import SwiftUI

public struct BedTimerTypography {
    // MARK: - Display Styles
    public static let largeTitle = Font.largeTitle.weight(.bold)
    public static let title1 = Font.title.weight(.semibold)
    public static let title2 = Font.title2.weight(.semibold)
    public static let title3 = Font.title3.weight(.medium)
    
    // MARK: - Body Styles
    public static let body = Font.body
    public static let bodyEmphasized = Font.body.weight(.medium)
    public static let callout = Font.callout
    public static let subheadline = Font.subheadline
    public static let footnote = Font.footnote
    public static let caption1 = Font.caption
    public static let caption2 = Font.caption2
    
    // MARK: - Custom Styles
    public static let countdownDisplay = Font.system(size: 48, weight: .bold, design: .rounded)
    public static let countdownLabel = Font.system(size: 16, weight: .medium, design: .rounded)
    public static let button = Font.system(size: 17, weight: .semibold, design: .default)
    public static let buttonLarge = Font.system(size: 20, weight: .semibold, design: .default)
    
    // MARK: - Watch Styles
    public static let watchLarge = Font.system(size: 34, weight: .bold, design: .rounded)
    public static let watchMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
    public static let watchSmall = Font.system(size: 16, weight: .medium, design: .rounded)
}

// MARK: - Dynamic Type Support
public extension BedTimerTypography {
    static func adaptive(_ baseFont: Font, for sizeCategory: ContentSizeCategory) -> Font {
        switch sizeCategory {
        case .extraSmall:
            return baseFont.size(0.8)
        case .small:
            return baseFont.size(0.9)
        case .medium:
            return baseFont.size(1.0)
        case .large:
            return baseFont.size(1.1)
        case .extraLarge:
            return baseFont.size(1.2)
        case .extraExtraLarge:
            return baseFont.size(1.3)
        case .extraExtraExtraLarge:
            return baseFont.size(1.4)
        case .accessibilityMedium:
            return baseFont.size(1.5)
        case .accessibilityLarge:
            return baseFont.size(1.6)
        case .accessibilityExtraLarge:
            return baseFont.size(1.7)
        case .accessibilityExtraExtraLarge:
            return baseFont.size(1.8)
        case .accessibilityExtraExtraExtraLarge:
            return baseFont.size(1.9)
        @unknown default:
            return baseFont
        }
    }
}

// MARK: - Font Extensions
public extension Font {
    static let bedTimer = BedTimerTypography.self
    
    func size(_ multiplier: CGFloat) -> Font {
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize * multiplier
        return .system(size: size)
    }
}