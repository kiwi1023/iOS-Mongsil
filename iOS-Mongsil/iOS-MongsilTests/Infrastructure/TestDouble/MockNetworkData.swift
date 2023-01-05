//
//  MockNetworkData.swift
//  iOS-MongsilTests
//
//  Created by Groot on 2023/01/05.
//

import Foundation

struct MockNetworkData {
    let data: Data?
    
    init(fileName: String) {
        let location = Bundle.main.url(forResource: fileName, withExtension: "json")
        self.data = try? Data(contentsOf: location!)
    }
}
