import SwiftUI

public struct BedTimerColors {
    // MARK: - Primary Colors
    public static let primary = Color("Primary", bundle: .module)
    public static let primaryVariant = Color("PrimaryVariant", bundle: .module)
    
    // MARK: - Secondary Colors
    public static let secondary = Color("Secondary", bundle: .module)
    public static let secondaryVariant = Color("SecondaryVariant", bundle: .module)
    
    // MARK: - Background Colors
    public static let background = Color("Background", bundle: .module)
    public static let surface = Color("Surface", bundle: .module)
    public static let surfaceVariant = Color("SurfaceVariant", bundle: .module)
    
    // MARK: - Text Colors
    public static let onPrimary = Color("OnPrimary", bundle: .module)
    public static let onSecondary = Color("OnSecondary", bundle: .module)
    public static let onBackground = Color("OnBackground", bundle: .module)
    public static let onSurface = Color("OnSurface", bundle: .module)
    
    // MARK: - Semantic Colors
    public static let success = Color("Success", bundle: .module)
    public static let warning = Color("Warning", bundle: .module)
    public static let error = Color("Error", bundle: .module)
    public static let info = Color("Info", bundle: .module)
    
    // MARK: - Countdown Colors
    public static let countdownActive = Color("CountdownActive", bundle: .module)
    public static let countdownWarning = Color("CountdownWarning", bundle: .module)
    public static let countdownCritical = Color("CountdownCritical", bundle: .module)
    
    // MARK: - Dark Mode Support
    public static func adaptive(_ light: Color, _ dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: - Color Extensions
public extension Color {
    static let bedTimer = BedTimerColors.self
}

// MARK: - Default Colors (Fallback)
public extension BedTimerColors {
    static let defaultPrimary = Color.blue
    static let defaultSecondary = Color.orange
    static let defaultSuccess = Color.green
    static let defaultWarning = Color.yellow
    static let defaultError = Color.red
    static let defaultInfo = Color.blue
}