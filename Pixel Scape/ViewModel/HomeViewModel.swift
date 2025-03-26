//
//  HomeViewModel.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import Foundation
import Combine

class HomeViewModel {
    
    @Published private(set) var searchText: String?
    @Published private(set) var imageData: Pixel?
    
    private let apiService = PixelApiService()
    private var isFetching = false
    
    init () {
        Task {
            fetchPixel()
        }
    }
    
    func fetchPixel(page: Int = 1, query: String? = nil) {
        Task{
            do {
                if let query, query != "" {
                    imageData = try await apiService.getSearchedWallpapers(query: query, page: page)
                } else {
                    imageData = try await apiService.getCuratedPhotos(page: page)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func loadMore(page: Int = 1, query: String? = nil) {
        guard !isFetching else { return }
        isFetching = true
        var data = Pixel(photos: [])
        
        Task{
            do {
                if let query, query != "" {
                    data = try await apiService.getSearchedWallpapers(query: query, page: page)
                } else {
                    data = try await apiService.getCuratedPhotos(page: page)
                }
                
                imageData?.photos.append(contentsOf: data.photos)
            } catch {
                print(error)
            }
            isFetching = false
        }
    }
    
}
