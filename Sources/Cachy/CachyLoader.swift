//
//  A.swift
//  Cachy
//
//  Created by sadman samee on 9/4/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import Foundation
import UIKit

public typealias CachyCallback = (Data, URL) -> Void
public typealias CachyImageCallback = (UIImage, URL) -> Void
public typealias CachyCallbackList = [CachyCallback]

open class CachyLoaderManager {
    public static let shared: CachyLoaderManager = {
        let instance = CachyLoaderManager()
        return instance
    }()
    
    fileprivate var cache: Cachy
    private var fetchList: [String: CachyCallbackList] = [:]
    private var fetchListOperationQueue: DispatchQueue = DispatchQueue(label: "cachy.awesome.fetchlist_queue",
                                                                       attributes: DispatchQueue.Attributes.concurrent)
    private var sessionConfiguration: URLSessionConfiguration!
    private var sessionQueue: OperationQueue!
    fileprivate lazy var defaultSession: URLSession! = URLSession(configuration:
        self.sessionConfiguration, delegate: nil,
                                   delegateQueue: self.sessionQueue)
    
    public func configure(memoryCapacity: Int = 30 * 1024 * 1024,
                          maxConcurrentOperationCount: Int = 10,
                          timeoutIntervalForRequest: Double = 3,
                          expiryDate: ExpiryDate = .everyWeek,
                          isOnlyInMemory: Bool = false,
                          isSupportingSecureCodingSaving: Bool = true) {
        cache.totalCostLimit = memoryCapacity
        cache.expiration = expiryDate
        
        Cachy.isOnlyInMemory = isOnlyInMemory
        Cachy.isSupportingSecureCodingSaving = isSupportingSecureCodingSaving
        
        sessionQueue = OperationQueue()
        sessionQueue.maxConcurrentOperationCount = maxConcurrentOperationCount
        sessionQueue.name = "cachy.awesome.session"
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .useProtocolCachePolicy
        sessionConfiguration.timeoutIntervalForRequest = timeoutIntervalForRequest
    }
    
    private init(memoryCapacity: Int = 30 * 1024 * 1024,
                 maxConcurrentOperationCount: Int = 10,
                 timeoutIntervalForRequest: Double = 3,
                 expiryDate: ExpiryDate = .everyWeek) {
        cache = Cachy()
        configure(memoryCapacity: memoryCapacity,
                  maxConcurrentOperationCount: maxConcurrentOperationCount,
                  timeoutIntervalForRequest: timeoutIntervalForRequest,
                  expiryDate: expiryDate)
    }
}

extension CachyLoaderManager {
    fileprivate func readFetch(_ key: String) -> CachyCallbackList? {
        return fetchList[key]
    }
    
    fileprivate func addFetch(_ key: String, callback: @escaping CachyCallback) -> Bool {
        var skip = false
        let list = fetchList[key]
        if list != nil {
            skip = true
        }
        fetchListOperationQueue.sync(flags: .barrier, execute: {
            if var fList = list {
                fList.append(callback)
                self.fetchList[key] = fList
            } else {
                self.fetchList[key] = [callback]
            }
        })
        return skip
    }
    
    fileprivate func removeFetch(_ key: String) {
        _ = fetchListOperationQueue.sync(flags: .barrier) {
            self.fetchList.removeValue(forKey: key)
        }
    }
    
    fileprivate func clearFetch() {
        fetchListOperationQueue.async(flags: .barrier) {
            self.fetchList.removeAll()
        }
    }
}

extension CachyLoaderManager {
    public func clear() {
        cache.clear()
        sessionConfiguration.urlCache?.removeAllCachedResponses()
    }
}

// MARK: - CachyLoader

open class CachyLoader: NSObject {
    var task: URLSessionTask?
    public override init() {
        super.init()
    }
}

extension CachyLoader {
    fileprivate func cacheKeyFromUrl(url: URL) -> String? {
        let path = url.absoluteString
        let cacheKey = path
        return cacheKey
    }
    
    fileprivate func dataFromFastCache(cacheKey: String) -> Data? {
        return CachyLoaderManager.shared.cache.get(forKey: cacheKey)
    }
    
    public func loadWithURLRequest(_ urlRequest: URLRequest,
                                   isRefresh: Bool = false,
                                   expirationDate: Date? = nil,
                                   callback: @escaping CachyCallback) {
        guard let url = urlRequest.url else {
            return
        }
        load(url: url,
             urlRequest: urlRequest,
             isRefresh: isRefresh,
             expirationDate: expirationDate,
             callback: callback)
    }
    
    public func loadWithURL(_ url: URL,
                            isRefresh: Bool = false,
                            expirationDate: Date? = nil,
                            callback: @escaping CachyCallback) {
        load(url: url,
             isRefresh: isRefresh,
             expirationDate: expirationDate,
             callback: callback)
    }
    
    private func load(url: URL,
                      urlRequest: URLRequest? = nil,
                      isRefresh: Bool = false,
                      expirationDate: Date? = nil,
                      callback: @escaping CachyCallback) {
        guard let fetchKey = self.cacheKeyFromUrl(url: url as URL) else {
            return
        }
        if !isRefresh {
            if let data = self.dataFromFastCache(cacheKey: fetchKey) {
                callback(data, url)
                return
            }
        }
        let cacheCallback = {
            (data: Data) -> Void in
            if let fetchList = CachyLoaderManager.shared.readFetch(fetchKey) {
                CachyLoaderManager.shared.removeFetch(fetchKey)
                DispatchQueue.main.async {
                    for f in fetchList {
                        f(data, url)
                    }
                }
            }
        }
        let skip = CachyLoaderManager.shared.addFetch(fetchKey, callback: callback)
        if skip {
            return
        }
        let session = CachyLoaderManager.shared.defaultSession
        let request = urlRequest ?? URLRequest(url: url)
        task = session?.dataTask(with: request, completionHandler: { data, _, _ in
            guard let data = data else {
                return
            }
            let object = CachyObject(value: data as NSData, key: fetchKey, expirationDate: expirationDate)
            CachyLoaderManager.shared.cache.add(object: object)
            cacheCallback(data)
        })
        task?.resume()
    }
}

extension CachyLoader {
    public func cancelTask() {
        guard let _task = self.task else {
            return
        }
        if _task.state == .running || _task.state == .running {
            _task.cancel()
        }
    }
}
