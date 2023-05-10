//
//  ChatView.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/5/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var openAiService: OpenAiService

    @State private var messageText = ""

    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(Array(openAiService.messages.enumerated()), id: \.element) { index, message in
                            ChatBubbleView(message: message)
                                .id(index)
                                .padding(.horizontal)
                        }
                    }
                    .onChange(of: openAiService.messages) { messages in
                        withAnimation {
                            proxy.scrollTo(messages.count - 1, anchor: .bottom)
                        }
                    }

                    HStack {
                        TextField(openAiService.textFieldPrompt, text: $messageText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .disabled(openAiService.interactionDisabled)

                        Button {
                            Task {
                                let preservedMessageText = messageText
                                messageText = ""
                                await openAiService.sendMessage(withText: preservedMessageText)
                            }
                        } label: {
                            Image(systemName: "paperplane")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(openAiService.interactionDisabled)
                    }
                    .padding(.horizontal)

                }
            }
            .navigationTitle("ChatGPT Room")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Error",
                isPresented: $openAiService.errorMessageIsShowing,
                actions: { Button("OK") { } },
                message: { Text(openAiService.errorMessageText) }
            )
        }
    }
}
// Preview isn't usable because OpenAiService's HTTPClient crashes every time
// OpenAiService is initialized in preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//            .environmentObject(OpenAiService())
//    }
//}
