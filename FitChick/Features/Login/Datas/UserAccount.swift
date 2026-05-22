//
//  UserAccount.swift
//  FitChick
//
//  Created by Vinka Alrezky As on 21/05/26.
//


import Foundation
import SwiftData

@Model
class UserAccount {
    @Attribute(.unique) var userId: String
    var petName: String
    var totalCoint: Int
    
    init(userId: String, petName: String = "", totalCoint: Int = 0) {
        self.userId = userId
        self.petName = petName
        self.totalCoint = totalCoint
    }
}
