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
    @Attribute(.unique) var idUser: String
    var petName: String
    var totalCoint: Int
    
    init(idUser: String, petName: String = "Chick", totalCoint: Int = 0) {
        self.idUser = idUser
        self.petName = petName
        self.totalCoint = totalCoint
    }
}
