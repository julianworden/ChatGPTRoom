//
//  Chat.Message+Helpers.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/9/23.
//

import Foundation
import OpenAIKit

extension Chat.Message: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }

    public static func == (lhs: Chat.Message, rhs: Chat.Message) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
