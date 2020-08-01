//
//  ExtensionInt.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

extension Int {
    func asAbbrevation() -> String? {
        let numberFormatter = NumberFormatter()

        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        
        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "K"),
            (100_000.0, 1_000_000.0, "M"),
            (100_000_000.0, 1_000_000_000.0, "B")
        ]

        let startValue = Double(abs(self))
        
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }

            return prevAbbreviation
        }()

        let value = Double(self) / abbreviation.divisor

        numberFormatter.locale = .init(identifier: "en_US_POSIX")
        numberFormatter.positiveSuffix = abbreviation.suffix
        numberFormatter.negativeSuffix = abbreviation.suffix
        numberFormatter.allowsFloats = true
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1

        return numberFormatter.string(from: .init(value: value))
    }
}
