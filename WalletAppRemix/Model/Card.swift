//
//  Card.swift
//  WalletAppRemix
//
//  Created by Алексей Зарицький on 18.10.2022.
//

import SwiftUI

// MARK: Sample Card View and data...
struct Card: Identifiable{
    var id = UUID().uuidString
    var name: String
    var cardNumber: String
    var cardImage: String
}

var cards: [Card] = [

    Card(name: "Alex", cardNumber: "4444 5678 1144 0004", cardImage: "card1"),
    Card(name: "Tom", cardNumber: "4572 7878 6871 2441", cardImage: "crad2"),
    Card(name: "Jessica", cardNumber: "1232 5674 8761 4561", cardImage: "card3"),
    Card(name: "John", cardNumber: "1452 5454 9051 1401", cardImage: "card4"),
]

