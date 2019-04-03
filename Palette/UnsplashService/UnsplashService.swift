//
//  UnsplashService.swift
//  Palette
//
//  Created by DevMountain on 4/2/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit.UIImage

class UnsplashService {
    
    static let shared = UnsplashService()
    
    var photos: [UnsplashPhoto] = []
    
    func fetchFromUnsplash(for unsplashRoute: UnsplashRoute, completion: @escaping ([UnsplashPhoto]?) -> Void){
        guard let url = unsplashRoute.fullUrl else { return }
        print(url.absoluteString)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil) ; return }
            do {
                let unsplashPhotos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                self.photos = unsplashPhotos
                completion(unsplashPhotos)
            }catch {
                print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchImage(for unsplashPhoto: UnsplashPhoto, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: unsplashPhoto.urls.small) else { completion(nil) ; return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil) ; return}
            completion(UIImage(data: data))
            }.resume()
    }
}
