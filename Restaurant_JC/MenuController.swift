//
//  MenuController.swift
//  Restaurant_JC
//
//  Created by James Chun on 3/20/19.
//  Copyright © 2019 James Chun. All rights reserved.
//

import Foundation

class MenuController {
    let baseURL: URL = URL(string: "http://localhost:8090/")!
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL: URL = baseURL.appendingPathComponent("categories")
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: categoryURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let data: Data = data,
                let jsonDictionary: [String: Any]? = try? JSONSerialization.jsonObject(with: data) as? [String: Any], //instead of .jsonDecoder, this is another way to decode JSON which allows you to use type [String: Any], or this could be [String: [String]], if you see "Any" in the dictionary, you have to use JSONSerialization
                let categories: [String] = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL: URL = baseURL.appendingPathComponent("menu")
        
        var components: URLComponents = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        
        let menuURL: URL = components.url!
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: menuURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder: JSONDecoder = JSONDecoder()
            if let data: Data = data,
                let menuItems: MenuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitOrder(forMenuIDs menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL: URL = baseURL.appendingPathComponent("order")
        
        // URLRequest object is needed because we are uploading to the server
        var request: URLRequest = URLRequest(url: orderURL) //url requst
        request.httpMethod = "POST" // url request method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //url content type
        
        // because we are ordering 4 items, we are going to put a dictionary of string and [Int] to the server
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder: JSONEncoder = JSONEncoder()
        let jsonData: Data? = try? jsonEncoder.encode(data) // if try? does not work it will give you nil
        request.httpBody = jsonData //url body: JSON
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder = JSONDecoder()
            if let data = data, //once we send the order, we receive preparation time from the server
                let preparationTime: PreparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        task.resume() //sends the order up to the server
    }
}
