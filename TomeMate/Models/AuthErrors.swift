//
//  AuthErrors.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import Foundation
import FirebaseAuth

enum TomeAuthError {
    // Login
    static func loginMessage(for error: Error) -> String {
        switch AuthErrorCode(rawValue: (error as NSError).code) {
        case .wrongPassword:
            return "The password you entered is incorrect."
        case .userNotFound:
            return "No account with that email was found."
        case .tooManyRequests:
            return "Too many requests. Please try again later."
        case .networkError:
            return "An network error occurred. Please try again later."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        default:
            return error.localizedDescription
        }
    }
    
    static func registerMessage(for error: Error) -> String {
        switch AuthErrorCode(rawValue: (error as NSError).code) {
        case .emailAlreadyInUse:
            return "An account with that email already exists."
        case .weakPassword:
            return "The password you entered is too weak. Please be above 6 characters."
        case .invalidEmail:
            return "The email you entered is invalid. Please try another email."
        case .networkError:
            return "An network error occurred. Please try again later."
        default:
            return error.localizedDescription
        }
    }
    
    static let passwordMismatch = "Passwords do not match. Please try again."
    static let passwordTooShort = "Password is too short. Make sure your password is 6 characters or more."
}
