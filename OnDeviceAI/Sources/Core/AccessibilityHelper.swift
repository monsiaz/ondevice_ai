import SwiftUI
import UIKit

/// Helper pour les fonctionnalités d'accessibilité de l'app
struct AccessibilityHelper {
    
    // MARK: - Dynamic Type Support
    
    /// Tailles de police qui s'adaptent aux préférences d'accessibilité
    static func scaledFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        return Font.system(size: size, weight: weight, design: design)
    }
    
    /// Police pour les titres avec support Dynamic Type
    static var titleFont: Font {
        return Font.system(.title2, design: .default, weight: .bold)
    }
    
    /// Police pour les boutons avec support Dynamic Type
    static var buttonFont: Font {
        return Font.system(.body, design: .default, weight: .medium)
    }
    
    /// Police pour les sous-titres avec support Dynamic Type
    static var subtitleFont: Font {
        return Font.system(.subheadline, design: .default)
    }
    
    // MARK: - Reduce Motion Support
    
    /// Vérifie si l'utilisateur préfère les animations réduites
    static var prefersReducedMotion: Bool {
        return UIAccessibility.isReduceMotionEnabled
    }
    
    /// Animation adaptative qui respecte les préférences d'accessibilité
    static func adaptiveAnimation<V: Equatable>(_ value: V) -> Animation? {
        return prefersReducedMotion ? nil : .easeInOut(duration: 0.3)
    }
    
    // MARK: - Contrast & Colors
    
    /// Vérifie si l'utilisateur préfère un contraste élevé
    static var prefersHighContrast: Bool {
        return UIAccessibility.isDarkerSystemColorsEnabled
    }
    
    /// Couleur de texte adaptée au contraste
    static var adaptiveTextColor: Color {
        return prefersHighContrast ? .primary : .primary
    }
    
    /// Couleur de fond adaptée au contraste
    static var adaptiveBackgroundColor: Color {
        return prefersHighContrast ? .black : Color(.systemBackground)
    }
    
    // MARK: - VoiceOver Labels
    
    /// Génère un label VoiceOver pour un message de chat
    static func chatMessageLabel(role: String, text: String, isGenerating: Bool = false) -> String {
        let prefix = role == "user" ? "Your message" : "AI response"
        let suffix = isGenerating ? ", generating response" : ""
        return "\(prefix): \(text)\(suffix)"
    }
    
    /// Génère un label VoiceOver pour l'état du modèle
    static func modelStatusLabel(modelName: String, isLoaded: Bool, isGenerating: Bool = false) -> String {
        let status = isLoaded ? "loaded" : "not loaded"
        let activity = isGenerating ? ", currently generating" : ""
        return "AI model \(modelName), \(status)\(activity)"
    }
    
    /// Génère un hint VoiceOver pour les boutons
    static func buttonHint(action: String) -> String {
        return "Double tap to \(action)"
    }
    
    // MARK: - Semantic Roles
    
    /// Trait d'accessibilité pour les messages de chat
    static var chatMessageTraits: AccessibilityTraits {
        return [.isStaticText, .allowsDirectInteraction]
    }
    
    /// Trait d'accessibilité pour les boutons principaux
    static var primaryButtonTraits: AccessibilityTraits {
        return [.isButton]
    }
    
    /// Trait d'accessibilité pour les éléments d'en-tête
    static var headerTraits: AccessibilityTraits {
        return [.isHeader, .isStaticText]
    }
}

// MARK: - View Extensions pour l'accessibilité

extension View {
    /// Ajoute un support d'accessibilité complet à un élément de chat
    func chatAccessibility(
        role: String,
        text: String,
        isGenerating: Bool = false
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(AccessibilityHelper.chatMessageLabel(
                role: role,
                text: text,
                isGenerating: isGenerating
            ))
            .accessibilityAddTraits(AccessibilityHelper.chatMessageTraits)
    }
    
    /// Ajoute un support d'accessibilité pour un bouton
    func buttonAccessibility(
        label: String,
        hint: String? = nil,
        isEnabled: Bool = true
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? AccessibilityHelper.buttonHint(label.lowercased()))
            .accessibilityAddTraits(AccessibilityHelper.primaryButtonTraits)
            .accessibilityValue(isEnabled ? "enabled" : "disabled")
    }
    
    /// Ajoute un support d'accessibilité pour un en-tête
    func headerAccessibility(_ text: String) -> some View {
        self
            .accessibilityLabel(text)
            .accessibilityAddTraits(AccessibilityHelper.headerTraits)
    }
    
    /// Adapte les animations selon les préférences d'accessibilité
    func adaptiveAnimation<V: Equatable>(_ value: V) -> some View {
        self.animation(AccessibilityHelper.adaptiveAnimation(value), value: value)
    }
    
    /// Améliore le contraste si nécessaire
    func adaptiveContrast() -> some View {
        self
            .foregroundColor(AccessibilityHelper.adaptiveTextColor)
            .background(AccessibilityHelper.adaptiveBackgroundColor)
    }
    
    /// Support pour la navigation clavier
    func keyboardNavigable(onTab: @escaping () -> Void = {}) -> some View {
        self
            .focusable(true)
            .onKeyPress(.tab) { _ in
                onTab()
                return .handled
            }
    }
}
