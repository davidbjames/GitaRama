//
//  Theme.swift
//  GitaRama
//
//  Created by David James on 6/21/22.
//

import C3

public class AppColors : SemanticPalette {
    public var dark = Color.red.s900.darker(by:0.1)
    public var light = Color.amber.a200
    public var accessibilityOverrides: AccessibilityOverrides?
    public var primary = Color.red.s600
    public var secondary = Color.amber.s600
    public var accent = Color.red.s500
    public var lightOnDarkIsNormal = false
}

public class AppFonts : SemanticFontSet {
    public lazy var title: UIFont = primary
    public lazy var text: UIFont = primary
    public var primary: UIFont = UIFont.system(design:.serif)
    public lazy var secondary: UIFont = primary
    public lazy var tertiary: UIFont = primary
}

public class AppStyleDefaults : ExtendedStyleDefaults {
    
}

extension Theme : ExtendedStyleAccessible {
    public static var colors = AppColors()
    public static var fonts = AppFonts()
    public static var defaults = AppStyleDefaults()
}

extension NSObject : ExtendedStyleAccessible {
    public static var colors = Theme.colors
    public static var fonts = Theme.fonts
    public static var defaults = Theme.defaults
    public var colors:AppColors { Theme.colors }
    public var fonts:AppFonts { Theme.fonts }
    public var defaults:AppStyleDefaults { Theme.defaults }
}

extension ThemeAccessible {
    public var defaultTheme:Theme {[
        
    ];}
}
extension UIView : ThemeAccessible {}
extension CALayer : ThemeAccessible {}
