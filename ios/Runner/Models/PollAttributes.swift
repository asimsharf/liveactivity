//
//  PollAttributes.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// PollAttributes.swift

// PollAttributes.swift

import ActivityKit

struct PollAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var question: String
        var options: [String]
        var votes: [Int]
        var endTime: Date
    }
    
    var pollName: String
}
