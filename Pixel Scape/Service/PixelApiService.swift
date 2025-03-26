//
//  PixelApiService.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import Foundation

class PixelApiService {
    
    private let baseUrl = "https://api.pexels.com/v1/"
    private let pageLimit = 20
    
    func getCuratedPhotos(page: Int) async throws -> Pixel {
        let endpoint = baseUrl + "curated?page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw PixelError.InvalidUrl
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = Keys.pixelAPIKey
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
            throw PixelError.invalidStatusCode
        } else {
            do {
                let wallpaper = try JSONDecoder().decode(Pixel.self, from: data)
                return wallpaper
            } catch {
                throw PixelError.jsonParsingFailed
            }
        }
    }
    
    func getSearchedWallpapers(query: String, page: Int) async throws -> Pixel {
        let endpoint = baseUrl + "search/?page=\(page)&query=\(query)"
        
        guard let url = URL(string: endpoint) else {
            throw PixelError.InvalidUrl
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = Keys.pixelAPIKey
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw PixelError.invalidStatusCode
        } else {
            do {
                let wallpaper = try JSONDecoder().decode(Pixel.self, from: data)
                return wallpaper
            } catch {
                throw PixelError.jsonParsingFailed
            }
        }
    }
}
