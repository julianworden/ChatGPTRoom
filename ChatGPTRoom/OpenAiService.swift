//
//  OpenAiService.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/5/23.
//

import AsyncHTTPClient
import NIO
import Foundation
import OpenAIKit

final class OpenAiService: ObservableObject {
    static let shared = OpenAiService()
    let openAiClient: Client

    var messages = [Chat.Message]()

    init() {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
//        defer { try? httpClient.syncShutdown() }
        let configuration = Configuration(apiKey: SecretConstants.openAiApiKey)
        openAiClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
    }

    func sendMessage(withText text: String) async {
        messages.append(Chat.Message.user(content: text))

        do {

            let completion = try await openAiClient.chats.create(
                model: Model.GPT3.gpt3_5Turbo,
                messages: messages,
                maxTokens: 1000
            )

            messages.append(completion.choices.last!.message)
            for message in messages {
                print("MESSAGE: \(message.content)")
            }
            print(completion.usage.totalTokens)
        } catch {
            print(error)
        }
    }
}
