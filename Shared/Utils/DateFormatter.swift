//
//  DateFormatter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 24.04.2023.
//

import Foundation

extension DateFormatter {
    
    static let iso8601Custom: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale =  Locale(identifier: "uk_UA_POSIX")
        
        return formatter
    }()
    
}
