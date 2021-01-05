//
//  ProfileViewModel.swift
//  Chatty
//
//  Created by Neha Patil on 1/3/21.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
