//
//  ViewState.swift
//  ChatGPTRoom
//
//  Created by Julian Worden on 5/9/23.
//

import Foundation

enum ViewState: Equatable {
    case performingWork
    case workCompleted
    case displayingView
    case error(message: String)
}
