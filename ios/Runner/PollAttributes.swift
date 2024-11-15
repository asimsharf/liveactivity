//
//  PollAttributes.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// PollAttributes.swift

import ActivityKit

struct PollAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var question: String
        var votes: [Int]
        var options: [String]
    }
    
    var question: String
}

