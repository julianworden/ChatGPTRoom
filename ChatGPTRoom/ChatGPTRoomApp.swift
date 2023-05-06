//
//  ChatGPTRoomApp.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/5/23.
//

import SwiftUI

@main
struct ChatGPTRoomApp: App {
    @StateObject private var openAiController = OpenAiService()

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environmentObject(openAiController)
        }
    }
}
