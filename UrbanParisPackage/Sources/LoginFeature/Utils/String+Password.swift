//
//  File.swift
//  
//
//  Created by Yassin El Mouden on 29/06/2024.
//

import Foundation

enum PasswordValidation: Int, CaseIterable, Identifiable, Equatable {
    var id: Int { self.rawValue }

    case hasAtLeastEightCharacter
    case hasLowerCharacter
    case hasUpperCharacter
    case hasNumber
    case hasSpecialCharacter

    var title: LocalizedStringResource {
        switch self {
        case .hasAtLeastEightCharacter:
            return "Au moins 8 caractères"
        case .hasLowerCharacter:
            return "Au moins une lettre miniscule"
        case .hasUpperCharacter:
            return "Au moins une lettre majuscule"
        case .hasNumber:
            return "Au moins un chiffre"
        case .hasSpecialCharacter:
            return "Au moins un caractère spécial"
        }
    }
}

extension String {
    func hasValidPassword() -> [PasswordValidation] {
        var correctValidations = [PasswordValidation]()

        if count >= 8 {
            correctValidations.append(.hasAtLeastEightCharacter)
        }

        // Vérifier s'il contient une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        let uppercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex)
        if uppercaseLetterPredicate.evaluate(with: self) {
            correctValidations.append(.hasUpperCharacter)
        }

        let lowercaseLetterRegex = ".*[a-z]+.*"
        let lowercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegex)
        if lowercaseLetterPredicate.evaluate(with: self) {
            correctValidations.append(.hasLowerCharacter)
        }

        let digitRegex = ".*[0-9]+.*"
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        if digitPredicate.evaluate(with: self) {
            correctValidations.append(.hasNumber)
        }

        let specialCharacterRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        if specialCharacterPredicate.evaluate(with: self) {
            correctValidations.append(.hasSpecialCharacter)
        }

        return correctValidations
    }

}
