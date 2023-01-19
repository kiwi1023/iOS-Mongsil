//
//  KeychainManager.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/19.
//

import Foundation

struct KeyChain {
    var userName: String = "Mongsil"
    var passWord: String
}

final class KeyChainManger {
    static let shared = KeyChainManger()
    
    private init() { }
    
    func addItemsOnKeyChain(_ newPassword: String) {
        let keyChain = KeyChain(passWord: newPassword)
        let passWord = keyChain.passWord.data(using: String.Encoding.utf8)!
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: keyChain.userName,
                                     kSecValueData as String: passWord]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else { return }
    }
    
    func readKeyChain() -> KeyChain? {
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecMatchLimit as String: kSecMatchLimitOne,
                                     kSecReturnAttributes as String: true,
                                     kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        guard let resultItem = item as? [String : Any],
              let passWordData = resultItem[kSecValueData as String] as? Data,
              let passWord = String(data: passWordData, encoding: String.Encoding.utf8),
              let userID = resultItem[kSecAttrAccount as String] as? String else {
            return nil
        }
        
        let keyChain = KeyChain(userName: userID, passWord: passWord)
        
        return keyChain
    }
    
    func updateItemOnKeyChain(_ newPassword: String) {
        let query: [String : Any] = [kSecClass as String: kSecClassGenericPassword]
        let keyChain = KeyChain(passWord: newPassword)
        let passWord = keyChain.passWord.data(using: String.Encoding.utf8)!
        let attributte: [String : Any] = [kSecAttrAccount as String : keyChain.userName,
                                          kSecValueData as String: passWord]
        let status = SecItemUpdate(query as CFDictionary, attributte as CFDictionary)
        
        guard status != errSecItemNotFound else { return }
        guard status == errSecSuccess else { return }
    }
    
    func deleteItemOnKeyChain() {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: "Mongsil"]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess {
            print("remove key-data complete")
        } else {
            print("remove key-data failed")
        }
    }
}

