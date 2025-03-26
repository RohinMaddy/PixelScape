//
//  Pixel.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import Foundation

struct Pixel: Codable {
    var photos: [Photos]
}

struct Photos: Codable, Identifiable {
    let id: Int
    let src: Src
}

struct Src: Codable {
    let original: String
    let medium: String
    let portrait: String
}
