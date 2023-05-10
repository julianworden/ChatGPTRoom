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

    @Published var messages = [Chat.Message]()
    @Published var interactionDisabled = false
    @Published var errorMessageIsShowing = false
    var errorMessageText = ""

    @MainActor
    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .performingWork:
                interactionDisabled = true
            case .workCompleted:
                interactionDisabled = false
            case .error(let message):
                errorMessageText = message
                errorMessageIsShowing = true
                interactionDisabled = false
            default:
                errorMessageText = "\(ErrorMessageConstants.invalidViewState): \(viewState)"
                errorMessageIsShowing = true
                interactionDisabled = false
            }
        }
    }

    @MainActor
    var textFieldPrompt: String {
        if viewState == .performingWork {
            return "Fetching response..."
        } else {
            return "Chat Message"
        }
    }

    let openAiClient: Client

    init() {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
//        defer { try? httpClient.syncShutdown() }
        let configuration = Configuration(apiKey: SecretConstants.openAiApiKey)
        openAiClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
    }

    @MainActor
    func sendMessage(withText text: String) async {
        do {
            viewState = .performingWork
            messages.append(Chat.Message.user(content: text))
            let response = try await getResponse()
            messages.append(response)
            viewState = .workCompleted
        } catch {
            viewState = .error(message: error.localizedDescription)
        }
    }

    func getResponse() async throws -> Chat.Message {
        let completion = try await openAiClient.chats.create(
            model: Model.GPT3.gpt3_5Turbo,
            messages: messages,
            maxTokens: 300
        )

        guard let newMessage = completion.choices.first?.message else { throw OpenAiError.noResponseFound }

        return newMessage
    }
}
