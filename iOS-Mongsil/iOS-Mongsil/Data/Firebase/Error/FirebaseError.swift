//
//  FirebaseError.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/30.
//

enum FirebaseError: Error {
    case delete
    case create
    case read
    case encoding
    case decoding
    case JSONSerialization
    case dataSnapshot
    case network
}
