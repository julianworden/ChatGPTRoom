//
//  OpenAiError.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/9/23.
//

import Foundation

enum OpenAiError: LocalizedError {
    case noResponseFound

    var errorDescription: String? {
        switch self {
        case .noResponseFound:
            return "ChatGPT responded to your query, but failed to generate a message. Please restart the app and try again."
        }
    }
}
