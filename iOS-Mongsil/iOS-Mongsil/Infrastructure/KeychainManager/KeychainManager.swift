//
//  KeychainManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/19.
//

import Foundation

enum KeyChain: String {
    case passWord
    case userIdentifier
    
    var userName: String {
        return self.rawValue
    }
}

final class KeyChainManger {
    static let shared = KeyChainManger()
    
    private init() { }
    
    func addItemsOnKeyChain(_ newPassword: String, dataType: KeyChain) {
        let passWord = newPassword.data(using: String.Encoding.utf8)!
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: dataType.userName,
                                     kSecValueData as String: passWord]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else { return }
    }
    
    func readKeyChain(dataType: KeyChain) -> String? {
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: dataType.userName,
                                     kSecMatchLimit as String: kSecMatchLimitOne,
                                     kSecReturnAttributes as String: true,
                                     kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        guard let resultItem = item as? [String : Any],
              let passWordData = resultItem[kSecValueData as String] as? Data,
              let passWord = String(data: passWordData, encoding: String.Encoding.utf8) else {
            return nil
        }

        return passWord
    }
    
    func updateItemOnKeyChain(_ newPassword: String, dataType: KeyChain) {
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword]
      
        let passWord = newPassword.data(using: String.Encoding.utf8)!
        let attributte: [String : Any] = [kSecAttrAccount as String : dataType.userName,
                                          kSecValueData as String: passWord]
        let status = SecItemUpdate(query as CFDictionary, attributte as CFDictionary)
        
        guard status != errSecItemNotFound else { return }
        guard status == errSecSuccess else { return }
    }
    
    func deleteItemOnKeyChain(dataType: KeyChain) {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: dataType.userName]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess {
            print("remove key-data complete")
        } else {
            print("remove key-data failed")
        }
    }
}
