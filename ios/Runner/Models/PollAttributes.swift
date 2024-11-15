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
        var question: String       // Poll question
        var endTime: Date          // End time for the poll countdown
    }
    
    var pollName: String          // Poll name or description
}
