//
//  DECasualTimeParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/16/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)((heute|diese[nrms])?\\s*(früh|nachmittag|abend|mittag))"
private let timeMatch = 4

public class DECasualTimeParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .german }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: OptionValue]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        if match.isNotEmpty(atRangeIndex: timeMatch) {
            let time = match.string(from: text, atRangeIndex: timeMatch).lowercased()
            switch time {
            case "früh":
                let option = opt[.morning]
                let hour = option?.hour ?? 6
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
            case "mittag":
                let option = opt[.noon]
                let hour = option?.hour ?? 12
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
            case "nachmittag":
                let option = opt[.afternoon]
                let hour = option?.hour ?? 15
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
                result.start.imply(.meridiem, to: 1)
            case "abend":
                let option = opt[.evening]
                let hour = option?.hour ?? 18
                let minute = option?.minute ?? 0
                result.start.imply(.hour, to: hour)
                result.start.imply(.minute, to: minute)
                result.start.imply(.meridiem, to: 1)
            default: break
            }
        }
        
        result.tags[.deCasualTimeParser] = true
        return result
    }
}
