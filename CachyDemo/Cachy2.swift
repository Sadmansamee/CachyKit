//
//  Cachy.swift
//  Cachy
//
//  Created by sadman samee on 9/4/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import Foundation
/*
 enum CachyDataType{

 }

 class Cachy{

 static let shared: Cachy = {
     let instance = Cachy(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "temp")
     return instance
 }()

 private  var memoryCapacity = 20 * 1024 * 1024
 private  var diskCapacity = 100 * 1024 * 1024
 private  var diskPath = "temp"
 private var urlCache: UrkCache!
 typealias DownloadCompletionHandler = (Result<Data, Error>) -> Void

 private func urlSession() -> URLSession {
     let config = URLSessionConfiguration.default
     config.requestCachePolicy = .returnCacheDataElseLoad
     config.urlCache = urlCache
     return URLSession(configuration: config)
 }

 private init(memoryCapacity: Int, diskCapacity: Int, diskPath: String) {
     urlCache = UrkCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
     //URLCache.shared = urlCache
 }

 func load(urlRequest: URLRequest, onCompletion : @escaping (Data) ->Void){

     if  let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest){
         onCompletion(cacheResponse.data)
     } else {

         //need to work on this thread
         let group = DispatchGroup()
         group.enter()

         //create data task to download data and having completion handler
         let task = urlSession().dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
             //below two lines will cache the data, request object as key
             if let response = response, let data = data {
                 let cacheResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowedInMemoryOnly)
                 URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
                 onCompletion(data)

                 //need to work on this thread
                 group.leave()
             }
         })
         task.resume()

     }
 }

 func load(url: String, onCompletion : @escaping (Data) ->Void){
     guard let url = URL(string: url) else {
         return
     }
     let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)

   if  let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest){
         onCompletion(cacheResponse.data)
     } else {

     //need to work on this thread
     let group = DispatchGroup()
     group.enter()

     //create data task to download data and having completion handler
     let task = urlSession().dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
         //below two lines will cache the data, request object as key
         if let response = response, let data = data {
             let cacheResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowedInMemoryOnly)
             URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
             onCompletion(data)

             //need to work on this thread
             group.leave()
         }
     })
     task.resume()

     }
 }

 }
 */
