//
//  ErrorMessage.swift
//  RickAndMortyApp
//
//  Created by Nihat on 26.03.2022.
//

import Foundation

enum ErrorMessage: String , Error {
    case invalidData = "The data received from the server was invalid.Please try again."
    case invalidResponse = "Invalid response from the server.Please try again."
    case unableToComplete = "Unable to complete your request.Please check your internet connection."
}
