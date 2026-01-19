//
//  DataServiceManager.swift
//  TSUMO
//
//  Created on 2025/01/27.
//

import Foundation

class DataServiceManager {
    static let shared = DataServiceManager()
    
    var dataService: DataServiceProtocol {
        if AppConfig.shared.isMockMode {
            return MockDataService.shared
        } else {
            return FirebaseService.shared
        }
    }
    
    private init() {}
}
