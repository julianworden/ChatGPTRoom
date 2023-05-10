//
//  ChatBubbleView.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/9/23.
//

import OpenAIKit
import SwiftPlus
import SwiftUI

struct ChatBubbleView: View {
    let message: Chat.Message

    var body: some View {
        switch message {
        case .assistant(let content):
            VStack(alignment: .leading) {
                Text("ChatGPT")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .padding(.bottom, -4)

                HStack {
                    Text(content)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])

                    Spacer()

                    Text(Date.now.formatted(date: .numeric, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

        case .user(let content):
            VStack(alignment: .trailing) {
                Text("You")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
                    .padding(.bottom, -4)

                HStack {
                    Text(Date.now.formatted(date: .numeric, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()

                    Text(content)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(.blue)
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft])
                }
            }
        default:
            Text("Different message type received: \(String(describing: message))")
        }
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubbleView(message: Chat.Message.assistant(content: "Why did the chicken cross the road?"))
            .padding(.horizontal)
    }
}
