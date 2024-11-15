//
//  TimerAttributes.swift
//  Runner
//
//  Created by asimsharf on 15/11/2024.
//

// TimerAttributes.swift

import ActivityKit

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var endTime: Date
    }

}
