//
//  ENCasualTimeParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/18/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)((this)?\\s*(morning|afternoon|evening|noon))"
private let timeMatch = 4

public class ENCasualTimeParser: Parser {
    override var pattern: String { return PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: OptionValue]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        if match.isNotEmpty(atRangeIndex: timeMatch) {
            let time = match.string(from: text, atRangeIndex: timeMatch)
            switch time {
            case "morning":
                let option = opt[.morning]
                let hour = option?.hour ?? 6
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
            case "noon":
                let option = opt[.noon]
                let hour = option?.hour ?? 12
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
            case "afternoon":
                let option = opt[.afternoon]
                let hour = option?.hour ?? 15
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
            case "evening":
                let option = opt[.evening]
                let hour = option?.hour ?? 18
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
            default: break
            }
        }
        
        result.tags[.enCasualTimeParser] = true
        return result
    }
}
