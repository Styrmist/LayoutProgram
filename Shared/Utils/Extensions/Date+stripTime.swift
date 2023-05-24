//
//  Date+stripTime.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 29.04.2023.
//

import Foundation

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        
        return date!
    }

}
