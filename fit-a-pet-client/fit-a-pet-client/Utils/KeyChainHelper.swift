import Foundation
import Security

class KeychainHelper {
    
    static func saveAccessToken(accessToken: String) {
        let keychainQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecValueData: accessToken.data(using: .utf8)!,
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        if status == errSecDuplicateItem {//값이 존재한다면 새로운 값으로 업데이트
            SecItemUpdate(keychainQuery as CFDictionary, [kSecValueData: accessToken.data(using: .utf8)!] as CFDictionary)
        } else if status != noErr {
            print("Failed to save AccessToken to Keychain")
        }
    }

    static func loadAccessToken() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "accessToken",
            kSecReturnData: kCFBooleanTrue!,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == noErr, let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
    
    static func savePassword(password: String) {
        let passwordQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "password",
            kSecValueData: password.data(using: .utf8)!,
        ]
        
        let status = SecItemAdd(passwordQuery as CFDictionary, nil)
        if status == errSecDuplicateItem {
            SecItemUpdate(passwordQuery as CFDictionary, [kSecValueData: password.data(using: .utf8)!] as CFDictionary)
        } else if status != noErr {
            print("Failed to save password to Keychain")
        }
    }
    
    static func loadPassword() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "password",
            kSecReturnData: kCFBooleanTrue!,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == noErr, let data = item as? Data, let password = String(data: data, encoding: .utf8) {
            return password
        } else {
            return nil
        }
    }
}

