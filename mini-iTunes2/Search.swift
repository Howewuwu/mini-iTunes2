//
//  Search.swift
//  mini-iTunes2
//
//  Created by Howe on 2023/3/23.
//

import Foundation
import UIKit


enum APIError: Error {
    case invalidURL
}


class Search {
    static let shared = Search()
    
    func searchMusic(searchTerm:String, offset:Int, country:String, completion:@escaping (Result<[iTunesItem], Error>) -> Void) {
        
        let encodeSearchString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?media=music&term=\(encodeSearchString)&offset=\(offset)&country=\(country)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(APIError.invalidURL))
        }
        URLSession.shared.dataTask(with: url) { data, reponse, error in
            if let data = data{
                do{
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.results))
                }catch{
                    completion(.failure(error))
                }
            }else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchImage(from url:URL, completion:@escaping(Result<UIImage,Error>)->()){
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,let image = UIImage(data:data) {
                completion(.success(image))
            }else if let error = error{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func lookup(trackId: Int, completion: @escaping (Result<iTunesItem, Error>) -> Void) {
        let urlString = "https://itunes.apple.com/lookup?id=\(trackId)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(APIError.invalidURL))
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    if let item = searchResponse.results.first {
                        completion(.success(item))
                    } else {
                        completion(.failure(APIError.invalidURL))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    
    
    
    
    
    
}
