//
//  ExtensionString.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

extension String {
    func asDate(dateFormat: String, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String? {
        let inputDateFormatter = DateFormatter()

        inputDateFormatter.dateFormat = dateFormat

        guard let date = inputDateFormatter.date(from: self) else {
            return nil
        }

        let outputDateFormatter = DateFormatter()

        outputDateFormatter.dateStyle = dateStyle
        outputDateFormatter.timeStyle = timeStyle
        
        return outputDateFormatter.string(from: date)
    }
}
