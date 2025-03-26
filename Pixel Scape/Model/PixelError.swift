//
//  PixelError.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import Foundation

enum PixelError: Error {
    case InvalidUrl
    case invalidData
    case jsonParsingFailed
    case requestFailed(description: String)
    case invalidStatusCode
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .InvalidUrl:
            return "Invalid Url"
        case .invalidData:
            return "Invalid Data"
        case .jsonParsingFailed:
            return "Failed to parse JSON data"
        case .requestFailed(let description):
            return "Request failed: \(description)"
        case .invalidStatusCode:
            return "Invalid status code"
        case .unknownError(let error):
            return "\(error.localizedDescription)"
        }
    }
}
