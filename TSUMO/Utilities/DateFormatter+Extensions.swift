//
//  DateFormatter+Extensions.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

extension DateFormatter {
    static let gameDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    static let yearMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
}
