//
//  ChatView.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/5/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var openAiController: OpenAiService

    @State private var messageText = ""

    var body: some View {
        VStack {
            ScrollView {

            }

            HStack {
                TextField("Chat Message", text: $messageText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task {
                        await openAiController.sendMessage(withText: messageText)
                        messageText = ""
                    }
                } label: {
                    Image(systemName: "paperplane")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(OpenAiService())
    }
}
